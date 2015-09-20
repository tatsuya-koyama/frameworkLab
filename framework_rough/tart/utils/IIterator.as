package tart.utils {

    public interface IIterator {

        function start():void;
        function current():*;
        function next():*;
        function hasNext():Boolean;

    }
}