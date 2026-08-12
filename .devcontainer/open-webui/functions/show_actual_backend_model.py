"""
title: Show Actual Backend Model
author: Nutanix
version: 0.1.0
"""

from typing import Optional


class Filter:
    def __init__(self):
        self._models = {}

    async def stream(
        self,
        event: dict,
        __event_emitter__=None,
        __metadata__: Optional[dict] = None,
    ) -> dict:

        metadata = __metadata__ or {}

        chat_id = metadata.get("chat_id", "")
        message_id = metadata.get("message_id", "")
        key = f"{chat_id}:{message_id}"

        model = event.get("model")

        if model and self._models.get(key) != model:
            self._models[key] = model

            if __event_emitter__:
                await __event_emitter__(
                    {
                        "type": "status",
                        "data": {
                            "description": f"Model used: {model}",
                            "done": True,
                            "hidden": False,
                            "action": "actual-backend-model",
                        },
                    }
                )

        return event