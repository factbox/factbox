/**
 * That component is installed via factbox/kanban, and present a customized list.
 * This code was initiated with the sample presented in: https://codesandbox.io/s/ql08j35j3q
 */
import React from 'react';
import {
  DragDropContext,
  Droppable,
  Draggable,
} from 'react-beautiful-dnd';
import LayerForm from './LayerForm';
import axios from 'axios';

const getItemStyle = (isDragging, draggableStyle) => ({
  // some basic styles to make the items look a bit nicer
  userSelect: 'none',

  // change background colour if dragging
  background: isDragging ? '#E4E5E5' : '#f8f9fa',

  // styles we need to apply on draggables
  ...draggableStyle,
});

/* eslint-disable react/prop-types */
const Layer = (props) => {
  const {
    id,
    title,
    stories,
    projectName,
    isDetached
  } = props;

  return (
    <Droppable droppableId={id}>
      {provided => (
        <div
          ref={provided.innerRef}
          className={isDetached ? "col-md-12" : "col-md-3"}
          {...provided.droppableProps}
        >
          <div className="card">
            <div className="card-body">
              <h4 className="card-title text-truncate py-2">
                {title}
              </h4>
              <div className={isDetached ? 'row' : ''}>
                { stories.map((story, index) => (
                  <Draggable
                    key={story.id}
                    draggableId={story.id}
                    index={index}
                  >
                    {(storyProvided, storySnapshot) => (
                      <div
                        ref={storyProvided.innerRef}
                        {...storyProvided.draggableProps}
                        {...storyProvided.dragHandleProps}
                        style={getItemStyle(
                          storySnapshot.isDragging,
                          storyProvided.draggableProps.style,
                        )}
                        className={`card p-2 bg-faded mb-2 ${isDetached ? 'ml-2 col-md-3' : ''}`}
                      >
                        <h5 className="card-title">
                          <a href={`/${projectName}/artifact/${encodeURI(story.title)}`}>
                            { story.title }
                          </a>
                        </h5>
                        <p>{ story.story }</p>
                      </div>
                    )}
                  </Draggable>
                ))}
                { provided.placeholder }
              </div>
            </div>
          </div>
        </div>
      )}
    </Droppable>
  );
}

// a little function to help us with reordering the result
const reorder = (list, startIndex, endIndex) => {
  const result = Array.from(list);
  const [removed] = result.splice(startIndex, 1);
  result.splice(endIndex, 0, removed);

  return result;
};

/**
 * Moves an item from one list to another list.
 */
const move = (source, destination, droppableSource, droppableDestination) => {
  const sourceClone = Array.from(source);
  const destClone = Array.from(destination);

  const [removed] = sourceClone.splice(droppableSource.index, 1);

  // update layer
  removed.layer_id = droppableDestination.droppableId;

  destClone.splice(droppableDestination.index, 0, removed);

  const result = {};
  result[droppableSource.droppableId] = sourceClone;
  result[droppableDestination.droppableId] = destClone;

  return result;
};

class Kanban extends React.Component {
  constructor(props) {
    super(props);

    const stories = JSON.parse(props.artifacts);
    const layers = JSON.parse(props.layers);

    stories.forEach(s => {
      if (s.layer_id === null) {
        s.layer_id = -1;
      }
    });

    this.state = {
      error: null,
      stories,
      layers,
      isLayerFormOpen: false,
    };
  }

  /**
   * Returns a list of stories
   */
  getList = (id) => {
    const { stories } = this.state;
    return stories.filter(s => s.layer_id === id);
  }

  /**
   * Fired when drop one item
   */
  onDragEnd = (result) => {
    const { source, destination } = result;

    // dropped outside the list
    if (!destination) {
      return;
    }

    if (source.droppableId === destination.droppableId) {
      const layerId = source.droppableId;

      const items = reorder(
        this.getList(layerId),
        source.index,
        destination.index,
      );

      const { stories } = this.state;
      const storiesExceptLayer = stories.filter(s => s.layer_id !== layerId);

      this.setState({
        stories: [...storiesExceptLayer, ...items],
      });
    } else {
      const sourceId = source.droppableId;
      const destinationId = destination.droppableId;

      console.info(sourceId);
      console.info(destinationId);

      // get story before move
      const story = this.getList(sourceId)[source.index];

      this.move(story, destinationId);

      const resultAfterMove = move(
        this.getList(sourceId),
        this.getList(destinationId),
        source,
        destination,
      );

      const updatedStories = [].concat(...Object.values(resultAfterMove));

      this.setState(prevState => ({
        stories: [...prevState.stories, updatedStories]
      }));
    }
  };

  /**
   * Request Rails API to update layer of story
   */
  move = (story, layer) => {
    const data = {
      id: story.id,
      layer: layer === -1 ? null : layer, // controller expect default layer has null
    };
    axios.post(`/kanban/move`, data);
  }

  /**
   * Request Rails API to create a new layer
   */
  createLayer = (layer) => {
    axios.post(`/layers`, layer)
      .then((res) => {
        const { response } = res.data;
        this.setState({
          error: null,
          isLayerFormOpen: false,
        });
      })
      .catch((err) => {
        const { error } = err.response.data;
        this.setState({
          error
        });
      });
  }

  toogleLayerForm = () => {
    this.setState(prevState => ({
      isLayerFormOpen: !prevState.isLayerFormOpen,
    }))
  }

  render() {
    const { project } = this.props;
    const { stories, layers, error, isLayerFormOpen } = this.state;

    return (
        <div className="container-fluid pt-3">
          <div className="row">
            <div className="col-md-auto">
              <h3>
                {project.name}
                <small> Kanban</small>
              </h3>
            </div>
            <div className="col-md-3">
              <div className="dropdown">
                <button
                  className="btn btn-secondary"
                  type="button"
                  onClick={this.toogleLayerForm}
                >
                  Add List
                </button>
                { isLayerFormOpen ? (
                  <div className="dropdown-menu px-2 show">
                    <LayerForm projectId={project.id} createLayer={this.createLayer} error={error}/>
                  </div> ) : null
                }
              </div>
            </div>
          </div>
          <DragDropContext onDragEnd={this.onDragEnd}>
            <div className="row mt-3">
                <Layer
                  id={-1}
                  projectName={project.name}
                  title={<span>Detached <i className="fa fa-thumbtack"></i></span>}
                  stories={stories.filter(s => s.layer_id === -1)}
                  isDetached
                />
            </div>
            <div className="row flex-row flex-sm-nowrap mt-3">
              {
                layers.map(l => (
                  <Layer
                    id={l.id}
                    projectName={project.name}
                    title={l.name}
                    stories={stories.filter(s => s.layer_id === l.id)}
                  />
                ))
              }
            </div>
          </DragDropContext>
        </div>
    );
  }
}

export default Kanban;
