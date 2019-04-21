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
    projectId,
  } = props;

  return (
    <Droppable droppableId={id}>
      {provided => (
        <div ref={provided.innerRef} className="col-sm-4 col-md-3">
          <div className="card">
            <div className="card-body">
              <h4 className="card-title text-truncate py-2">
                {title}
              </h4>
              { stories.lenght === 0 ? (
                <h5 className="text-secondary">Empty</h5>
              ) : (
                <div>
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
                          className="card p-2 bg-faded mb-2"
                        >
                          <h5 className="card-title">
                            <a href={`/${projectId}/artifact/${story.title}`}>
                              { story.title }
                            </a>
                          </h5>
                          <p>{ story.story }</p>
                        </div>
                      )}
                    </Draggable>
                  ))}
                </div>
              )
              }
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
  removed.layer = droppableDestination.droppableId;

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
    const ids = [];

    // identify all layers
    stories.forEach((s) => {
      if (!ids.includes(s.layer)) {
        ids.push(s.layer);
      }
    });

    this.state = {
      stories,
      ids,
    };
  }

  /**
   * Returns a list of stories
   */
  getList = (id) => {
    const { stories } = this.state;

    return stories.filter(s => s.layer === id);
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
      const items = reorder(
        this.getList(source.droppableId),
        source.index,
        destination.index,
      );

      const { stories } = this.state;
      const storiesExceptLayer = stories.filter(s => s.layer !== source.droppableId);

      this.setState({
        stories: [...storiesExceptLayer, ...items],
      });
    } else {
      // get story before move
      const story = this.getList(source.droppableId)[source.index];

      this.move(story, destination.droppableId);

      const resultAfterMove = move(
        this.getList(source.droppableId),
        this.getList(destination.droppableId),
        source,
        destination,
      );

      const updatedStories = [].concat(...Object.values(resultAfterMove));

      this.setState({
        stories: updatedStories,
      });
    }
  };

  /**
   * Request Rails API to update layer of story
   */
  move = (story, layer) => {
    fetch(`/kanban/${story.id}/move/${layer}`)
      .then((res) => {
        console.info(JSON.parse(res.json()));
      });
  }

  render() {
    const { project } = this.props;
    const { stories, ids } = this.state;

    return (
      <DragDropContext onDragEnd={this.onDragEnd}>
        <div className="container-fluid pt-3">
          <h3>
            {project.name}
            <small> Kanban</small>
          </h3>
          <div className="row flex-row flex-sm-nowrap py-5">
            {
              ids.map(id => (
                <Layer
                  id={id}
                  projectId={project.id}
                  title={stories.find(s => s.layer === id).layer}
                  stories={stories.filter(s => s.layer === id)}
                />
              ))
            }
          </div>
        </div>
      </DragDropContext>
    );
  }
}

export default Kanban;
