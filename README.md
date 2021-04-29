# d57-website-builder

This repository holds the source code of a Docker image which is used to build
and deploy my websites.

## Included Softwares

- **Elixir v1.11.4** for static website generator (Serum) support
- **Imagemagick** for generating thumbnails
- **Cairo and Pango** for generating URL "card" images
- **Dart Sass** for compiling Sass files into CSS
- **Node.js** and **Google Firebase CLI** for website deployment
- **An (oversized) toolchain** for building [cairo\_elixir](https://github.com/Dalgona/cairo_elixir) NIF library
- And a homebrew Discord webhook client for status reporting

## Required Environment Variables

- `DISCORD_WEBHOOK_ID`
- `DISCORD_WEBHOOK_TOKEN`
- `FIREBASE_TOKEN`

If run in a GitHub Actions workflow, the following environment variables are
automatically set by the CI system:

- `GITHUB_REPOSITORY`
- `GITHUB_REF`
- `GITHUB_SHA`

## Acknowledgements

This Docker image uses the following fonts to generate URL card preview images:

- [Iosevka](https://typeof.net/Iosevka/)
- [Spoqa Han Sans Neo](https://spoqa.github.io/spoqa-han-sans/)

These fonts are released under the SIL Open Font License. The copyright notice
and the license text itself for each font is included in this repository.
