# Complex Markdown Parsing Test Document

---

## Basic Elements

### Headers

# H1
## H2
### H3
#### H4
##### H5
###### H6

### Emphasis

- *Italic*
- **Bold**
- ***Bold and Italic***
- ~~Strikethrough~~

### Lists

- Unordered list item 1
  - Nested unordered item 1
    - Deeper nested item
- Unordered list item 2

1. Ordered list item 1
   1. Nested ordered item
      1. Deeper nested item
2. Ordered list item 2

### Links

- [OpenAI](https://www.openai.com)
- [Reference-style link][1]

[1]: https://example.com

### Images

![Test Image](https://example.com/image.png "Example Image")

### Blockquotes

> Blockquote level 1
>> Nested blockquote
>>> Even deeper blockquote

### Code

Inline `code` example.

```python
def greet(name):
    return f"Hello, {name}!"
```

```json
{
    "key": "value",
    "array": [1, 2, 3]
}
```

---

## Advanced Elements

### Tables

| Syntax | Description |
|--------|-------------|
| Header | Title       |
| Paragraph | Text     |

### Task Lists

- [x] Completed task
- [ ] Incomplete task
  - [x] Nested completed task
  - [ ] Nested incomplete task

### Footnotes

Here's a statement that requires clarification.[^1]

[^1]: Footnote providing additional information.

### HTML Elements

<div style="border: 1px solid black; padding: 10px;">
  <p>This is a paragraph inside a div element.</p>
</div>

### Horizontal Rules

***

---

### Escaped Characters

\*Not italic\*  
\# Not header

### Autolinks

<https://www.openai.com>

---

## Edge Cases

### Mixed Content Block

- **Bold list item with `inline code` and [a link](https://example.com).**

> Blockquote with
> 
> - Nested List
>   - Nested inside blockquote

```markdown
Nested code block
- with markdown-like syntax
```

### Special Characters

| Pipe | Backslash | Asterisk | Underscore | Backticks |
|------|-----------|----------|------------|-----------|
| \|   | \\        | \*      | \_        | \`       |

---
