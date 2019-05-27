import React from 'react';

const InputCriteria = ({ content, id, remove }) => (
  <div className="input-group mt-2">
    <input
      id={`criteria-${id}`}
      className="form-control string required"
      type="text"
      placeholder="Type one acceptance criteria"
      name="artifact[criterias_attributes][][content]"
      value={content}
    />
    <div className="input-group-prepend">
      <button
        onClick={() => remove()}
        type="button"
        className="btn btn-light"
        alt="Delete criteria"
      >
        <i className="fa fa-times" />
      </button>
    </div>
  </div>
);

class CriteriaForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      idCount: 1,
      criterias: props.criterias.length > 0 ?
        this.createCriteriaInputs(props.criterias)
        :
        {
          0: <InputCriteria id={0} remove={() => this.remove(0)} />,
        },
    };
  };

  createCriteriaInputs = (criterias) => {
    const inputCriterias = {};

    criterias.forEach((obj, i) => {
      inputCriterias[i] = (
        <InputCriteria
          id={i}
          remove={() => this.remove(i)}
          content={obj.content}
        />
      );
    }, {});

    return inputCriterias;
  }

  remove = id => {
    this.setState(prevState=> ({
      criterias: {...prevState.criterias, [id]: undefined },
    }));
  };

  add = () => {
    const { idCount, criterias } = this.state;
    this.setState({
      idCount: idCount + 1,
      criterias: {
        ...criterias,
        [idCount]: <InputCriteria id={idCount} remove={() => this.remove(idCount)} />,
      },
    });
  };

  render() {
    const { criterias } = this.state;

    return (
      <div>
        <div className="form-group">
          <label className="form-control-label text optional">
            Criterias
          </label>
          { Object.values(criterias) }
        </div>
        <button onClick={this.add} type="button" className="btn btn-light mb-2">
          Add Criteria <i className="fa fa-plus" />
        </button>
      </div>
    );
  }
};

export default CriteriaForm;
