# meltano-docker

# mel.sh

`mel.sh` is a command-line tool for running Meltano commands and managing Docker containers.

## Usage

To use `mel.sh`, run the following command:

```shell
mel.sh [meltano|container|shell|...] <args>
```

- `meltano`: Run Meltano commands inside the meltano container.
- `container`: Run docker-compose commands.
  - `build`: Build the Docker images specified in the docker-compose.yml file.
  - `up`: Start the Docker containers defined in the docker-compose.yml file.
  - `down`: Stop the Docker containers defined in the docker-compose.yml file.
- `shell`: Run commands inside the meltano container's shell.

## Examples

Here are some example usages:

- Run Meltano command:
  ```shell
  mel.sh meltano <meltano-command>
  ```

- Manage Docker containers:
  ```shell
  mel.sh container build
  mel.sh container up
  mel.sh container down
  ```

- Run commands inside the meltano container's shell:
  ```shell
  mel.sh shell <command>
  ```
  
## Documentation

For more information, refer to the documentation or visit the project's repository.

Feel free to modify and enhance the content as needed. If you have any further questions, please let me know!