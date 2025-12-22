cl import from .....utils { provideYear }

cl {
    def Footer()  -> any {
        return <footer className="bg-blue-600 text-white py-8 px-4">
            <div className="max-w-7xl mx-auto flex flex-col sm:flex-row justify-between items-center gap-4">
                <div className="text-center sm:text-left">
                    <h3 className="text-2xl font-extrabold tracking-wide text-yellow-300 flex items-center gap-1">
                        <span className="rounded-full bg-white text-blue-600 px-2 py-1">
                            S
                        </span>
                        kill
                        <span className="rounded-full bg-white text-blue-600 px-2 py-1">
                            A
                        </span>
                        tlas
                    </h3>
                    <p className="text-sm text-blue-100">
                        Guiding Kenyan youth toward smarter career decisions.
                    </p>
                </div>
                <div className="flex flex-col sm:flex-row gap-3 text-center text-sm text-blue-100">
                    <a
                        href="/about"
                        className="hover:underline"
                    >
                        About
                    </a>
                    <a
                        href="/contact"
                        className="hover:underline"
                    >
                        Contact
                    </a>
                    <a
                        href="/privacy"
                        className="hover:underline"
                    >
                        Privacy Policy
                    </a>
                </div>
                <div className="text-center text-sm text-blue-100">
                    © {provideYear()} SkillAtlas. All rights reserved.
                </div>
            </div>
        </footer>;
    }
}
