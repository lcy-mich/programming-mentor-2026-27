package lcymich.projects.model;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

public class Model {

    private DataFrame dataFrame;
    private final HashMap<String, Integer> idIndexed = new HashMap<>();;
    private final ArrayList<String> unindexedIds;
    private final int idIndex;


    public Model(int idIndex) {
        this.idIndex = idIndex;

        dataFrame = DataLoader.getDataFrame("data"+File.pathSeparator+"patients100.csv");
        unindexedIds = dataFrame.getColumn(idIndex).getRows();
        indexIds();
    }

    public void indexIds() {
        for (int i = unindexedIds.size() - 1; i >= 0; i--) {
            idIndexed.put(unindexedIds.get(i), );
        }
    }

    public ArrayList<String> getRecord(String id) {
        int index = idIndexed.get(id);


    }

}
