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


@WebServlet("/patientList")
public class ViewPatientListServlet extends HttpServlet
{

  /**
   * Handles HTTP GET requests.
   * This is the primary method for retrieving the patient list.
   *
   * @param request  the HttpServletRequest object that contains the request the client has made of the servlet
   * @param response the HttpServletResponse object that contains the response the servlet sends to the client
   * @throws ServletException if the request for the GET could not be handled
   * @throws IOException      if an input or output error is detected when the servlet handles the GET request
   */
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
  {
    try {
      Model model = ModelFactory.getModel();

      HashMap<String, String> idAndPatientNames = model.getIdAndPatientNames();

      // This makes the 'patientNames' list accessible to the JSP page for rendering.
      request.setAttribute("idAndPatientNames", idAndPatientNames);

      // 4. Invoke the JSP for display.
      // RequestDispatcher.forward() is used to send the request/response objects to another resource (JSP).
      ServletContext context = getServletContext();
      RequestDispatcher dispatch = context.getRequestDispatcher("/patientList.jsp");
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

  /**
   * Handles HTTP POST requests.
   * Redirects to doGet as viewing a list is typically an idempotent operation.
   *
   * @param request  the HttpServletRequest object that contains the request the client has made of the servlet
   * @param response the HttpServletResponse object that contains the response the servlet sends to the client
   * @throws ServletException if the request for the POST could not be handled
   * @throws IOException      if an input or output error is detected when the servlet handles the POST request
   */
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    doGet(request, response);
  }
}
