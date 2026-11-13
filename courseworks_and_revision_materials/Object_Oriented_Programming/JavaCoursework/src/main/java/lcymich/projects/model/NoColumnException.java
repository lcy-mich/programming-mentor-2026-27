package lcymich.projects.model;

public class NoColumnException extends RuntimeException{
    public NoColumnException(String e){
        super("Cannot find column "+e);
    }
}