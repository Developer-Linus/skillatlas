import from backend.models.models { UserData, UserRole }
walker save_user_profile {
    has email: str;
    has target_role: str;

    can start with `root entry {
        visit [here-->(`?UserData)] else {
            new_user = here ++> UserData(
                email=self.email,
                role=UserRole.USER.value,
                target_role=self.target_role
            );
            visit [-->new_user];
        }
    }

    can update_email_and_targetrole with UserData entry {
        here.email = self.email;
        here.target_role = self.target_role;

        report {
            "success": True,
            "user": {"email": here.email, "target_role": here.target_role}
        } ;
    }
}
