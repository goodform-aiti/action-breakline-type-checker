# Breakline-type-checker
Validate LF CR format


## Example usage

```yml
name: Lint

on: [push]

jobs:
  breakline-checker:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@master
    - name: breakline format checker
      uses: ateli-development/Breakline-type-checker@master
      env:
        MODIFIED_FILES: ${{ steps.file_changes.outputs.files}}
```
