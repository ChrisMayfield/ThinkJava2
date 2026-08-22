# java-runner embeds

Minimal HTML for iframe embeds (e.g. WordPress strips inline `<script>` in post bodies).

## Collatz example

File: `collatz-conjecture.html`

After pushing to `master`, iframe URL (serves as HTML, not plain text):

```html
<iframe
  src="https://raw.githack.com/ChrisMayfield/ThinkJava2/master/quarto/embed/collatz-conjecture.html"
  width="100%"
  height="420"
  style="border:1px solid #e0e0e0;border-radius:6px;"
  loading="lazy"
  title="Collatz conjecture — interactive Java">
</iframe>
```

`raw.githubusercontent.com` alone does **not** work in iframes (wrong MIME type). Use [raw.githack.com](https://raw.githack.com/) or GitHub Pages.

java-runner assets load from the book’s GitHub Pages build (`/assets/javarunner/`).
