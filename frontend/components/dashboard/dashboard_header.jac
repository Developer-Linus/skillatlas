cl {
    def DashboardHeader(user_email: str, target_role: str) -> any {
        <div class="card mb-6 flex justify-between items-center">
            <div>
                <h1 class="section-heading">
                    Welcome, {user_email}!
                </h1>
                <p class="text-gray-600">
                    Target Role:
                    <span class="font-semibold">
                        {target_role}
                    </span>
                </p>
            </div>
            <div>
                <button class="primary-btn">
                    Edit Profile
                </button>
            </div>
        </div>;
    }
}
