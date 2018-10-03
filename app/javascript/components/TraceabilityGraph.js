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

    const { nodes } = props;

    this.state = {
      nodes: JSON.parse(nodes),
    };
  }

  render() {
    const { nodes } = this.state;

    const graph = {
      nodes: nodes,
      edges: [
          {from: 8, to: 10},
      ]
    };

    return (
      <Graph graph={graph} options={options} events={events} />
    );
  }
}

export default TraceabilityGraph;
