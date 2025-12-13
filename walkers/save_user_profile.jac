import from models.models { UserData, UserRole }
walker SaveUserProfile {
    has email: str;
    has target_role: str;

    can start with `root entry {
        # Visit UserData nodes if they exist, else create one
        visit [here-->(`?UserData)] else {
            here ++> UserData(
                email=self.email,
                role=UserRole.USER.value,
                target_role=self.target_role
            );
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
