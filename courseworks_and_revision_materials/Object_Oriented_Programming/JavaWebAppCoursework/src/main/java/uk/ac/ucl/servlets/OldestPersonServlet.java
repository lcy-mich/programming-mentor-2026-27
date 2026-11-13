package uk.ac.ucl.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uk.ac.ucl.model.Model;
import uk.ac.ucl.model.ModelFactory;
import uk.ac.ucl.model.NoColumnException;
import uk.ac.ucl.model.NotFoundException;

import java.io.IOException;

@WebServlet("/oldest")
public class OldestPersonServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Model model = ModelFactory.getModel();

            int oldestIndex = model.getOldestPersonIndex();

            String[] record = model.getRecordFromRow(oldestIndex);
            String[] columnNames = model.getColumnNames();

            request.setAttribute("record", record);
            request.setAttribute("columnNames", columnNames);

            ServletContext context = getServletContext();
            RequestDispatcher dispatch = context.getRequestDispatcher("/patientInfo.jsp");
            dispatch.forward(request, response);

        } catch (NoColumnException | NotFoundException e) {
            request.setAttribute("errorMessage", e.getMessage());
            forwardError(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading data: " + e.getMessage());
            forwardError(request, response);
        }
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ServletContext context = getServletContext();
        RequestDispatcher dispatch = context.getRequestDispatcher("/error.jsp");
        dispatch.forward(request, response);
    }
}