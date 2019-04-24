import React from 'react';

class LayerForm extends React.Component {
  constructor(props) {
    super(props);
    const { projectId } = this.props;

    this.state = {
      layer: {
        name: '',
        project_id: projectId,
      }
    }
  }

  /**
  * Change form fields
  */
  handleChange = (evt) => {
    const { name, value } = evt.target;

    this.setState(prevState => ({
      layer: {
        ...prevState.layer,
        [name]: value,
      },
    }));
  }

  handleSubmit = (evt) => {
    const { createLayer } = this.props;
    const { layer } = this.state;

    createLayer(layer);
  }

  render() {
    const { error } = this.props;
    return (
      <div>
        <div className="form-group">
          <input
            type="text"
            name="name"
            onChange={this.handleChange}
            placeholder="Name"
            className={`form-control ${ error ? 'is-invalid string required' : ''}`}
          />
          { error ? (
              <div className="invalid-feedback mw-100">
                { error.name[0] }
              </div>
            ) : null
          }
        </div>
        <button onClick={this.handleSubmit} className="btn btn-primary mb-2">
          New Layer
        </button>
      </div>
    );
  }
}

export default LayerForm;
