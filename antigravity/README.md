# Antigravity

[Antigravity](https://antigravity.google/) is an agentic IDE from Google.

## Prerequisites

1. Install [Antigravity](https://antigravity.google/) locally.

2. Install Podman:

   ```sh
   sudo apt install podman
   ```

   You can also use Docker if you have that available and prefer it, or another
   container builder and runner tool, but you'll have to update the `runner.sh`
   script accordingly.

## Build and run the container

1. Build the container:

   ```sh
   $ ./runner.sh build
   ```

2. Configure your local environment, e.g., Antigravity install directory, your
   work directory, etc.

   Create a file `local.sh` with the vars set at the top of `runner.sh` to
   update them.

   For example, if you download the Antigravity IDE tarball and expand it in
   your `${HOME}/Downloads` folder, and you are working on some projects in
   `${HOME}/projects` directory, configure `local.sh` as follows:

   ```sh
   ANTIGRAVITY_IDE_INSTALL="${HOME}/Downloads/Antigravity IDE"
   MAPPED_HOME_DIR="${HOME}/projects"
   ```

3. Start Antigravity IDE inside the container:

   ```sh
   $ ./runner.sh run
   ```

   > Note: exiting Antigravity inside the container will exit the container!

   If you want to be able to drop into the shell inside the container, or run
   other processes inside the container in parallel to the Antigravity IDE, or if
   you want to debug the container or processes inside it, instead run:

   ```sh
   $ ./runner.sh shell
   ```

   and then start Antigravity inside the container manually using the command
   line at the end of the `Containerfile`.
