package lcymich.projects;

import lcymich.projects.model.DataFrame;
import lcymich.projects.model.DataLoader;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    static void main() {
        //TIP Press <shortcut actionId="ShowIntentionActions"/> with your caret at the highlighted text
        // to see how IntelliJ IDEA suggests fixing it.
        DataFrame df = DataLoader.getDataFrame("D:\\Projects\\JavaCoursework\\data\\patients100.csv");

        for (String str : df.getColumnNames()) {
            System.out.print(str+"\t");
        }
        System.out.println();
        for (int i = 0; i < df.getRowCount() - 1; i++) {
            for (String name : df.getColumnNames()) {
                try {
                    System.out.print(df.getValue(name, i) + "\t");
                }
                catch (Exception e) {
                    e.printStackTrace();
                }
            }
            System.out.println();
        }
    }
}
