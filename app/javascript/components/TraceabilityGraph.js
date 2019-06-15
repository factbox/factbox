import React from 'react';
import PropTypes from 'prop-types';
import Graph from 'react-graph-vis';

const options = {
  height: window.innerHeight * 0.8,
  width: '100%',
  edges: {
    color: '#3498db',
  },
};

const events = {

};

export class TraceabilityGraph extends React.Component {

  constructor(props) {
    super(props);

    const { nodes, edges } = props;

    this.state = {
      nodes: JSON.parse(nodes),
      edges: JSON.parse(edges),
      captions: this.mountCaption(nodes),
    };
  }

  mountCaption = (nodes) => {
    const captions = {'#7f8c8d': 'Old version'};

    JSON.parse(nodes).map(n => {
      const color = n.color.background;
      if (!Object.keys(captions).includes(color)) {
        captions[color] = n.name;
      }
    });

    return captions;
  }

  render() {
    const { nodes, edges, captions } = this.state;

    const graph = {
      nodes,
      edges,
    };

    return (
      <div>
        <div class="container">
          <div class="row">
            <div class="col-md-2 ml-2">
              <hr
                style={{
                  backgroundColor: '#FFF', borderTop: '1px solid #000'
                }}
              />
              Source
            </div>
            <div class="col-md-2">
              <hr
                style={{
                  backgroundColor: '#FFF', borderTop: '1px dashed #000'
                }}
              />
              Next version
            </div>
            {
              Object.keys(captions).map(c => (
                <div
                  class="col-md-1 ml-1 text-center align-middle"
                  style={{backgroundColor: c}}>
                    { captions[c] }
                </div>
              ))
            }
          </div>
        </div>
        <Graph graph={graph} options={options} events={events} />
      </div>
    );
  }
}

TraceabilityGraph.propTypes = {
  nodes: PropTypes.isRequired,
  edges: PropTypes.isRequired,
};

export default TraceabilityGraph;
