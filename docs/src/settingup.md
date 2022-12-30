# Setting Up (for beginners)

Using a notebook environment like Pluto or Jupyter doesn't work well when developing and contributing to an open source package. This page is a quick set up guide for using [Visual Studio Code (VSCode)](https://code.visualstudio.com/) with the Julia extension to develop MicroTracker.jl.

!!! note
    This is by no means the only way to accomplish this. This is just the method I prefer and have found the easiest while developing MicroTracker.

## VS Code
1. Install [Visual Studio Code](https://code.visualstudio.com/) and the Julia extension. 
2. Ensure you can run a hello world julia script, detailed in the [getting started](https://www.julia-vscode.org/docs/stable/gettingstarted/) page.
3. Get accustomed to running code in the integrated Julia REPL in VSCode using keybinds like `shift+enter` and `ctrl+enter`. This is also detailed in the extension docs [here](https://www.julia-vscode.org/docs/stable/userguide/runningcode/).
4. Add [Revise.jl](https://timholy.github.io/Revise.jl/stable/) to your base Julia environment. By default, the VSCode Julia extension detects that its available and automatically loads it when starting a Julia extension integrated REPL in VSCode.

## GitHub Desktop
1. Download [Github Desktop](https://desktop.github.com/).
2. File -> Clone Repository -> paste in the URL for MicroTracker.jl. `https://github.com/czimm79/MicroTracker.jl`.
3. Right click on Current Repository (MicroTracker.jl) -> Open in Visual Studio Code.

## Setting up environment
The dependent packages for MicroTracker normally automatically install behind the scenes when you use `] add MicroTracker` in the REPL. When developing, we need to instantiate that dependency environment.
1. Open the command palette in VSCode (`ctrl+shift+p`) and select `Julia: Start REPL`. Activate the MicroTracker environment:

```julia-REPL
(v1.8) pkg> activate .
```
2. You should be able to run the `test` command in the `pkg` mode and all tests should pass. You are now ready to make changes!

