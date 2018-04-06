package baldrick.macros;

// adapted from https://code.haxe.org/category/macros/add-git-commit-hash-in-build.html
class Version {
    private static var warnedAboutGitHash:Bool = false;

    public static macro function getGitCommitHash():haxe.macro.Expr.ExprOf<Null<String>> {
        #if !display
        var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
        if(process.exitCode() != 0) {
            if(!warnedAboutGitHash) {
                haxe.macro.Context.warning('There is no git hash, entity state will be unversioned!', haxe.macro.Context.currentPos());
                warnedAboutGitHash = true;
            }
            return macro $v{null};
        }
        
        // read the output of the process
        var commitHash:String = process.stdout.readLine();
        
        // Generates a string expression
        return macro $v{commitHash};
        #else 
        // `#if display` is used for code completion. In this case returning an
        // empty string is good enough; We don't want to call git on every hint.
        var commitHash:String = "";
        return macro $v{commitHash};
        #end
    }
}