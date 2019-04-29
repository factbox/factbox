/* eslint-disable react/prop-types */
import React from 'react';
import MarkdownIt from 'markdown-it';

const md = new MarkdownIt();

class MarkdownForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      content: props.content,
      markdown: '',
    };
    this.textarea = React.createRef();
  }

  setMarkdown = markdown => this.setState({ markdown });

  handleChange = (evt) => {
    const { value } = evt.target;

    this.setState({
      content: value,
    });
  }

  handlePreview = () => {
    const content = this.textarea.current.value;
    const markdown = md.render(content);
    this.setMarkdown(markdown);
  };

  render() {
    const { content, markdown } = this.state;
    return (
      <div>
        <nav>
          <div className="nav nav-tabs" id="nav-tab" role="tablist">
            <a
              className="nav-item nav-link active"
              id="nav-form-tab"
              data-toggle="tab"
              href="#nav-form"
              role="tab"
              aria-controls="nav-form"
              aria-selected="true"
            >
              Form
            </a>
            <a
              className="nav-item nav-link"
              id="nav-preview-tab"
              data-toggle="tab"
              href="#nav-preview"
              role="tab"
              aria-controls="nav-preview"
              aria-selected="false"
              onClick={this.handlePreview}
            >
              Preview Markdown
            </a>
          </div>
        </nav>
        <div
          className="tab-content"
          id="nav-tabContent"
        >
          <div
            className="tab-pane fade show active"
            id="nav-form"
            role="tabpanel"
            aria-labelledby="nav-form-tab"
          >
            <label
              className="form-control-label text optional"
              htmlFor="artifact[content]"
            >
              Content
            </label>
            <textarea
              rows="15"
              className="form-control is-valid text optional"
              name="artifact[content]"
              ref={this.textarea}
              value={content}
              onChange={this.handleChange}
            />
          </div>
          <div className="tab-pane fade" id="nav-preview" role="tabpanel" aria-labelledby="nav-preview-tab">
            <div
              dangerouslySetInnerHTML={{ __html: markdown }}
              style={{
                height: this.textarea.current ? this.textarea.current.clientHeight : '100%'
              }}
              className="border mt-2 p-3"
            >
              {/* markdown will be rendered here */}
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default MarkdownForm;
