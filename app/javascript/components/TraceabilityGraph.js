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
    };
  }

  render() {
    const { nodes, edges } = this.state;

    const graph = {
      nodes,
      edges,
    };

    return (
      <div>
        <Graph graph={graph} options={options} events={events} />
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
          </div>
        </div>
      </div>
    );
  }
}

TraceabilityGraph.propTypes = {
  nodes: PropTypes.isRequired,
  edges: PropTypes.isRequired,
};

export default TraceabilityGraph;
