
extension GenerateCommand {
  
      /**
      This method allows for the use of git repositories to hold templates in addition to passing in a flat template file.

      - Parameter from: The string passed in from the command line
      - Returns: Returns the Path of the template file

      ## Important Notes ##
      1. template.yml file should be top level of the git repository
      2. template repositories will be downloaded to a .genesis folder in users home (~) directory
      3. Each download replaces prior versions of the template

    */
    func determinePath(from: String) -> Path {

      if
        from.contains("http")  ||
        from.contains("https") ||
        from.contains("git")
      {

        do {

          let project = URL(string: from)!.lastPathComponent.components(separatedBy: ".")[0]

          let mkdirCommand  = try shellOut(to: "ls .genesis 2>/dev/null || mkdir .genesis", at: "~")

          print("removing existing template")
          let deleteCommand = try shellOut(to: "rm -rf .genesis/\(project)", at: "~")

          print("cloning repository")
          let cloneCommand = try shellOut(to: "git clone --verbose \(from)", at: "~/.genesis")

          return Path("~/.genesis/\(project)/template.yml").absolute()

        } catch {

          print(error)
          exit(1)

        }

      } else {

        return Path(from).absolute()

      }

    }
}