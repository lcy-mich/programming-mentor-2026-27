package lcymich.projects.model;

import java.util.ArrayList;

public class DataFrame {

    private final ArrayList<Column> columns;

    public DataFrame() {
        columns = new ArrayList<>();
    }

    public void addColumn(Column column) {
        columns.add(column);
    }

    public void addColumn(String name) {
        this.addColumn(new Column(name));
    }

    public String[] getColumnNames() {
        if (columns.isEmpty()) return new String[0];

        String[] names = new String[columns.size()];

        for (int i = 0; i < columns.size(); i++) {
            names[i] = columns.get(i).getName();
        }

        return names;
    }

    public int getRowCount() {
        if (columns.isEmpty()) return 0;

        return columns.getFirst().getSize();
    }

    public Column getColumn(String columnName) throws NoColumnException {
        for (Column column : columns) {
            if (column.getName().equals(columnName)) {
                return column;
            }
        }
        throw new NoColumnException(columnName);
    }

    public Column getColumn(int index) {
        return columns.get(index);
    }

    public String getValue(String columnName, int row) throws NoColumnException {
         return getColumn(columnName).getRowValue(row);
    }

    public void putValue(String columnName, int row, String value) throws NoColumnException {
        getColumn(columnName).setRowValue(row, value);
    }

    public void addValue(String columnName, String value) throws NoColumnException {
        getColumn(columnName).addRowValue(value);
    }

    public String[] getRowRecord(int row) {
        String[] rowRecord = new String[columns.size()];

        for (int i = 0; i < columns.size(); i++) {
            rowRecord[i] = columns.get(i).getRowValue(row);
        }

        return rowRecord;
    }

}
