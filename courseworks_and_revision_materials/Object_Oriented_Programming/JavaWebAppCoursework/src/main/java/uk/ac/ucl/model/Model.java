package uk.ac.ucl.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.text.DecimalFormat;
import java.util.Collections;
import java.util.List;

public class Model {

    private DataFrame dataFrame;

    public void readFile(String path) throws IOException {
        dataFrame = DataLoader.getDataFrame(path);
    }

    public ArrayList<HashMap<String, String>> searchFor(String keyword) {
        ArrayList<HashMap<String, String>> records = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return records;
        }
        String lowerKeyword = keyword.toLowerCase();
        String[] columnNames = dataFrame.getColumnNames();

        for (int row = 0; row < dataFrame.getRowCount(); row++) {
            HashMap<String, String> matchedColumns = new HashMap<>();

            for (String colName : columnNames) {
                String value = dataFrame.getValue(colName, row);
                if (value != null && value.toLowerCase().contains(lowerKeyword)) {
                    matchedColumns.put(colName, value);
                }
            }

            if (!matchedColumns.isEmpty()) {
                String id = dataFrame.getValue("ID", row);
                matchedColumns.put("ID", id);

                String firstName = dataFrame.getValue("FIRST", row);
                String lastName = dataFrame.getValue("LAST", row);
                String fullName = (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
                matchedColumns.put("Fullname", fullName.trim());

                records.add(matchedColumns);
            }
        }
        return records;
    }


    private int getIndexFromID(String ID) throws NotFoundException {
        for (int rowindex = 0; rowindex < dataFrame.getRowCount(); rowindex++) {
            if (dataFrame.getColumn(0).getRowValue(rowindex).equals(ID)) {
                return rowindex;
            }
        }
        throw new NotFoundException("No index found with ID: "+ ID);
    }

    public HashMap<String, String> getIdAndPatientNames() throws NoColumnException {
        HashMap<String, String> patientNames = new HashMap<>();

        ArrayList<String> ids = dataFrame.getColumn("ID").getRows();
        ArrayList<String> firstName = dataFrame.getColumn("FIRST").getRows();
        ArrayList<String> lastName = dataFrame.getColumn("LAST").getRows();

        for (int i = 0; i < firstName.size(); i++) {
            String fullName = firstName.get(i) + " " + lastName.get(i);
            patientNames.put(ids.get(i), fullName);
        }

        return patientNames;
    }

    public String[] getRecordFromID(String ID) {
        int index = getIndexFromID(ID);

        return dataFrame.getRowRecord(index);
    }

    public String[] getColumnNames() {
        return dataFrame.getColumnNames();
    }

    private int computeAge(String birthDateStr, String deathDateStr) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate birth = LocalDate.parse(birthDateStr, formatter);
        LocalDate end = (deathDateStr == null || deathDateStr.isEmpty())
                ? LocalDate.now()
                : LocalDate.parse(deathDateStr, formatter);

        int age = end.getYear() - birth.getYear();
        if (end.getMonthValue() < birth.getMonthValue() ||
                (end.getMonthValue() == birth.getMonthValue() && end.getDayOfMonth() < birth.getDayOfMonth())) {
            age--;
        }
        return age;
    }

    public String[] getRecordFromRow(int row) {
        return dataFrame.getRowRecord(row);
    }

    public int getOldestPersonIndex() throws NoColumnException, NotFoundException {
        Column birthColumn = dataFrame.getColumn("BIRTHDATE");
        Column deathColumn;
        try {
            deathColumn = dataFrame.getColumn("DEATHDATE");
        } catch (NoColumnException e) {
            deathColumn = null;
        }

        int maxAge = -1;
        int oldestRow = -1;

        for (int row = 0; row < dataFrame.getRowCount(); row++) {
            String birth = birthColumn.getRowValue(row);
            if (birth == null || birth.isEmpty()) continue;

            String death = (deathColumn != null) ? deathColumn.getRowValue(row) : null;
            try {
                int age = computeAge(birth, death);
                if (age > maxAge) {
                    maxAge = age;
                    oldestRow = row;
                }
            } catch (Exception e) {
                // Skip rows with invalid date format
            }
        }

        if (oldestRow == -1) {
            throw new NotFoundException("No valid birthdate found in the dataset.");
        }
        return oldestRow;
    }

    public HashMap<String, Integer> getCityCounts() throws NoColumnException {
        Column cityColumn = dataFrame.getColumn("CITY");
        HashMap<String, Integer> counts = new HashMap<>();
        for (int row = 0; row < cityColumn.getSize(); row++) {
            String city = cityColumn.getRowValue(row);
            if (city != null && !city.isEmpty()) {
                counts.put(city, counts.getOrDefault(city, 0) + 1);
            }
        }
        return counts;
    }

    public HashMap<String, String> getAgeStatistics() throws NoColumnException, NotFoundException {
        Column birthColumn = dataFrame.getColumn("BIRTHDATE");
        Column deathColumn;
        try {
            deathColumn = dataFrame.getColumn("DEATHDATE");
        } catch (NoColumnException e) {
            deathColumn = null;
        }

        List<Integer> ages = new ArrayList<>();

        for (int row = 0; row < dataFrame.getRowCount(); row++) {
            String birth = birthColumn.getRowValue(row);
            if (birth == null || birth.isEmpty()) continue;

            String death = (deathColumn != null) ? deathColumn.getRowValue(row) : null;
            try {
                int age = computeAge(birth, death);
                ages.add(age);
            } catch (Exception e) {
                // skip invalid dates
            }
        }

        if (ages.isEmpty()) {
            throw new NotFoundException("No valid age data found.");
        }

        int maxAge = Collections.max(ages);
        int minAge = Collections.min(ages);
        double avgAge = ages.stream().mapToInt(Integer::intValue).average().orElse(0.0);
        int ageRange = maxAge - minAge;

        DecimalFormat df = new DecimalFormat("#.##");

        HashMap<String, String> stats = new HashMap<>();
        stats.put("maxAge", String.valueOf(maxAge));
        stats.put("minAge", String.valueOf(minAge));
        stats.put("avgAge", df.format(avgAge));
        stats.put("ageRange", String.valueOf(ageRange));

        return stats;
    }
}
