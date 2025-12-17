cl import from react { useState }
cl import from "../layout.Header" { Header }

cl {
    def DashboardLayout(props: dict) -> any {
        [sidebarOpen, setSidebarOpen] = useState(True);
        [infoOpen, setInfoOpen] = useState(True);

        return <div className="min-h-screen bg-gray-50">
            <Header />

            <div className="flex h-[calc(100vh-72px)]">
                # {/* Sidebar */}
                {sidebarOpen and <DashboardSidebar />}

                # {/* Main */}
                <main className="flex-1 overflow-y-auto p-6">
                    {props.children}
                </main>

                # Info Panel
                {infoOpen and <DashboardInfoPanel />}
            </div>
        </div>;
    }
}
