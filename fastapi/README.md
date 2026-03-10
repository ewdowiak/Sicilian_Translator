# Sicilian Translator / fastapi

Sharing a translation model works better when it works faster.

The `main.py` script in this directory is a hack-a-doodle rewrite of [Sockeye](https://awslabs.github.io/sockeye/)'s `translate.py` for web translation with [FastAPI](https://fastapi.tiangolo.com/).

Running the application with [Uvicorn](https://uvicorn.dev/), `uvicorn main:app --reload`, loads the translations model's parameters and keeps them ready for translation.
