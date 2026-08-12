#!/usr/bin/env python3

import asyncio
from pathlib import Path

from open_webui.models.functions import (
    FunctionForm,
    FunctionMeta,
    Functions,
)


FUNCTION_ID = "show_actual_backend_model"
FUNCTION_NAME = "Show Actual Backend Model"

FUNCTION_FILE = Path(
    "/opt/nai/functions/show_actual_backend_model.py"
)


async def main():
    content = FUNCTION_FILE.read_text()

    form = FunctionForm(
        id=FUNCTION_ID,
        name=FUNCTION_NAME,
        content=content,
        meta=FunctionMeta(
            description="Displays the actual backend model returned by the AI gateway."
        ),
    )

    existing = await Functions.get_function_by_id(FUNCTION_ID)

    if existing:
        print(f"Updating Open WebUI function: {FUNCTION_ID}")

        await Functions.update_function_by_id(
            FUNCTION_ID,
            {
                "name": FUNCTION_NAME,
                "content": content,
                "meta": form.meta.model_dump(),
                "type": "filter",
                "is_active": True,
                "is_global": True,
            },
        )

    else:
        print(f"Creating Open WebUI function: {FUNCTION_ID}")

        function = await Functions.insert_new_function(
            user_id="nai-staging",
            type="filter",
            form_data=form,
        )

        if function is None:
            raise RuntimeError(
                f"Failed to create Open WebUI function {FUNCTION_ID}"
            )

        await Functions.update_function_by_id(
            FUNCTION_ID,
            {
                "is_active": True,
                "is_global": True,
            },
        )

    print(
        f"Open WebUI function {FUNCTION_ID} installed and enabled"
    )


if __name__ == "__main__":
    asyncio.run(main())