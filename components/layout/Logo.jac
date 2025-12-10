cl import from "@jac-client/utils" { Link }

cl {
    def Logo()  -> any {
        return <Link
            to="/"
            className="logo flex flex-col sm:flex-row sm:items-center gap-1"
        >
            <div className="logo-title flex flex-wrap items-center gap-1 sm:gap-1.5 text-xl sm:text-2xl font-bold">
                <span className="inline-flex items-center justify-center w-5 h-5 sm:w-7 sm:h-7 border-2 border-blue-600 rounded-full">
                    S
                </span>
                kill
                <span className="inline-flex items-center justify-center w-5 h-5 sm:w-7 sm:h-7 border-2 border-blue-600 rounded-full">
                    A
                </span>
                tlas
            </div>
            <div className="logo-subtitle text-xs sm:text-sm text-teal-500">
                Smart Career Navigator
            </div>
        </Link>;
    }
}
