package au.edu.rmit.sept.eventhub.controllers;

import au.edu.rmit.sept.eventhub.models.User;
import au.edu.rmit.sept.eventhub.services.UserService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

interface test;

@WebMvcTest(LoginController.class)
class LoginControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserService userService;

    /**
     * @AcceptanceCriteriaId 29.1
     * 29.1: Create new account
     * Given a new valid email and password
     * When the user fill then press sign up
     * Then an account is created.
     * @see au.edu.rmit.sept.eventhub.controllers.LoginController#signUpSubmit(String, String, String, String, org.springframework.ui.Model, jakarta.servlet.http.HttpServletRequest)
     */
    @Test
    @WithMockUser
    @DisplayName("AC-29.1 Sign up with valid details creates an account and forwards to sign-in")
    void signup_valid_createsAccount_andForwardsToSignIn() throws Exception {
        when(userService.emailExists("newuser@test.com")).thenReturn(false);

        User saved = new User();
        saved.setId(123);
        saved.setUsername("NewUser");
        saved.setEmail("newuser@test.com");
        when(userService.create(any(User.class))).thenReturn(saved);

        mockMvc.perform(post("/sign-up")
                        .with(csrf())
                        .param("username", "NewUser")
                        .param("email", "newuser@test.com")
                        .param("password", "Secret123!")
                        .param("confirmPassword", "Secret123!"))
                .andExpect(status().isOk()) // forward returns 200
                .andExpect(forwardedUrl("/sign-in"));

        verify(userService).create(any(User.class));
        verify(userService).createAttendee(saved.getId().intValue());
    }

    /**
     * @AcceptanceCriteriaId 29.2
     * 29.2: Invalid email message
     * Given an existing or invalid email
     * When the user signs up
     * Then the system shows an error message.
     * @see au.edu.rmit.sept.eventhub.controllers.LoginController#signUpSubmit(String, String, String, String, org.springframework.ui.Model, jakarta.servlet.http.HttpServletRequest)
     */
    @Test
    @WithMockUser
    @DisplayName("AC-29.2 Sign up with existing email shows error and stays on sign-up page")
    void signup_existingEmail_showsError() throws Exception {
        when(userService.emailExists("taken@test.com")).thenReturn(true);

        mockMvc.perform(post("/sign-up")
                        .with(csrf())
                        .param("username", "Anyone")
                        .param("email", "taken@test.com")
                        .param("password", "Whatever1!")
                        .param("confirmPassword", "Whatever1!"))
                .andExpect(status().isOk())
                .andExpect(view().name("general/signUp"))
                .andExpect(model().attributeExists("error"))
                .andExpect(model().attribute("error", "Email is already registered"));
    }
}
