import React from 'react';
import MarkdownIt from 'markdown-it';

const md = new MarkdownIt();

const Markdown = ({ content }) => (
  <div
    dangerouslySetInnerHTML={{ __html: md.render(content) }}
    className="mt-2 p-3"
  >
    {/* markdown will be translated here */}
  </div>
);

export default Markdown;
