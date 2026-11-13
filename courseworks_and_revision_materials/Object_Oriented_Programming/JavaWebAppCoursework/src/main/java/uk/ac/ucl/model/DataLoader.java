package uk.ac.ucl.model;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import java.io.FileReader;
import java.io.IOException;

import java.util.List;

public class DataLoader {

    public static DataFrame getDataFrame(String csvFilePath) throws IOException {

        DataFrame dataFrame = new DataFrame();

        try (FileReader reader = new FileReader(csvFilePath);
            CSVParser csvParser = CSVFormat.DEFAULT.builder().setHeader().get().parse(reader)) {

            List<String> headerNames = csvParser.getHeaderNames();
            headerNames.forEach(dataFrame::addColumn);

            for (CSVRecord record : csvParser.getRecords()) {
                try {
                    for (String headerName : headerNames) {

                        dataFrame.addValue(headerName, record.get(headerName));
                    }
                }
                catch (NoColumnException e) {
                    System.out.println("NO COLUMN: "+e.getMessage());
                }
            }
        }

        return dataFrame;
    }
}
