import ".styles.css";
import from .pages.HomePage { HomePage }
import from .components.auth.SignUp { SignupPage }
import from .components.auth.Login { LoginPage }
import from .components.onboarding.onboarding { Onboarding }

import from react { useState, useEffect }
import from "@jac-client/utils" { Router, Routes, Route, Navigate, Link, useNavigate }
