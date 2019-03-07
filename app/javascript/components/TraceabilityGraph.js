import React from "react"
import PropTypes from "prop-types"
import Graph from "react-graph-vis"

const options = {
  height: window.innerHeight * 0.8,
  width: '100%',
  // layout: {
  //   hierarchical: true
  // },
  edges: {
    color: "#3498db"
  }
};

const events = {
    select: function(event) {
        var { nodes, edges } = event;
    }
}

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
      nodes: nodes,
      edges: edges,
    };

    return (
      <Graph graph={graph} options={options} events={events} />
    );
  }
}

export default TraceabilityGraph;
