# d57-website-builder

This repository holds the source code of a Docker image which is used to build
and deploy my websites.

## Included Softwares

- **Elixir v1.10.4** for static website generator (Serum) support
- **Imagemagick** for thumbnail generation
- **Dart Sass** for compiling Sass files into CSS
- **Node.js** and **Google Firebase CLI** for website deployment
- And a homebrew Discord webhook client for status reportings

## Required Environment Variables

- `DISCORD_WEBHOOK_ID`
- `DISCORD_WEBHOOK_TOKEN`
- `FIREBASE_TOKEN`

If run in a GitHub Actions workflow, the following environment variables are
automatically set by the CI system:

- `GITHUB_REPOSITORY`
- `GITHUB_REF`
- `GITHUB_SHA`
