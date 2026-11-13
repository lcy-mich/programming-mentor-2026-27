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
import java.util.HashMap;

@WebServlet("/ageinfo")
public class AgeInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Model model = ModelFactory.getModel();
            HashMap<String, String> stats = model.getAgeStatistics();
            request.setAttribute("stats", stats);
            ServletContext context = getServletContext();
            RequestDispatcher dispatch = context.getRequestDispatcher("/ageInfo.jsp");
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