package uk.ac.ucl.model;

public class NoColumnException extends RuntimeException{
    public NoColumnException(String e){
        super("Cannot find column "+e);
    }
}