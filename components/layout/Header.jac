cl import from .Logo { Logo }
cl import from .NavMenu { NavMenu }

cl {
    def Header()  -> any {
        return <header className="w-full bg-gray-50 shadow-md">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex flex-col sm:flex-row items-center justify-between gap-4">
                <Logo />
                <NavMenu />
            </div>
        </header>;
    }
}
