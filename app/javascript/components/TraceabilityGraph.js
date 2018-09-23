import React from "react"
import PropTypes from "prop-types"
import Graph from "react-graph-vis"

const graph = {
  nodes: [
      {id: 1, label: 'Story 01', color: "#95a5a6", borderWidth: 0},
      {id: 2, label: 'Story 02', color: "#95a5a6", borderWidth: 0},
      {id: 3, label: 'Story 03', color: "#95a5a6", borderWidth: 0},
      {id: 4, label: 'Story 04', color: "#95a5a6", borderWidth: 0},
      {id: 5, label: 'Story 05', color: "#95a5a6", borderWidth: 0}
    ],
  edges: [
      {from: 1, to: 2},
      {from: 1, to: 3},
      {from: 2, to: 4},
      {from: 2, to: 5}
    ]
};

const options = {
  height: window.innerHeight * 0.8,
  width: '100%',
  layout: {
    hierarchical: true
  },
  edges: {
    color: "#000000"
  }
};

const events = {
    select: function(event) {
        var { nodes, edges } = event;
    }
}

export class TraceabilityGraph extends React.Component {
  render() {
    return (
      <Graph graph={graph} options={options} events={events} />
    );
  }
}

export default TraceabilityGraph;
