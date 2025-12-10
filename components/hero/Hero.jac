cl import from "@jac-client/utils" { Link }

cl {
    def Hero()  -> any {
        return <section className="hero bg-gradient-to-b from-white to-blue-50 py-20 px-6">
            <div className="max-w-7xl mx-auto flex flex-col lg:flex-row items-center gap-12">
                <div className="hero-text flex-1 flex flex-col gap-6">
                    <h1 className="text-5xl sm:text-4xl font-bold text-blue-600 leading-tight">
                        Transform Your Career Journey
                    </h1>
                    <p className="text-lg sm:text-base text-gray-700 max-w-lg">
                        SkillAtlas helps you discover opportunities, track skill growth, and navigate your career path smarter and faster. See your transformation in real time.
                    </p>
                    <div className="hero-buttons flex gap-4 mt-4 flex-wrap">
                        <Link
                            to="/signup"
                            className="px-6 py-3 rounded-full bg-blue-600 text-white hover:bg-blue-700 transition font-semibold"
                        >
                            Get Started
                        </Link>
                        <Link
                            to="/learn-more"
                            className="px-6 py-3 rounded-full border-2 border-blue-600 text-blue-600 hover:bg-blue-50 transition font-semibold"
                        >
                            Learn More
                        </Link>
                    </div>
                </div>
                <div className="hero-image flex-1 flex justify-center">
                    <img
                        src="/static/assets/hero-transformation.png"
                        alt="Career transformation illustration"
                        className="w-full max-w-md rounded-xl shadow-lg"
                    />
                </div>
            </div>
        </section>;
    }
}
