cl import from react { useState }

cl {
    def Features()  -> any {
        return <section className="bg-gray-50 py-16 px-4 sm:py-20 sm:px-6">
            <div className="max-w-7xl mx-auto flex flex-col gap-10">
                <h2 className="text-center text-3xl sm:text-4xl font-bold text-blue-600">
                    What Makes SkillAtlas Powerful
                </h2>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div className="bg-white p-6 rounded-2xl shadow-md border border-gray-100 hover:shadow-blue-200 transition">
                        <div className="text-4xl mb-3">
                            🎯
                        </div>
                        <h3 className="text-xl font-semibold text-blue-700 mb-2">
                            Personalized Career Guidance
                        </h3>
                        <p className="text-gray-600">
                            AI analyzes your skills, interests, and trends to give youprecise career direction — not generic suggestions.
                        </p>
                    </div>
                    <div className="bg-white p-6 rounded-2xl shadow-md border border-gray-100 hover:shadow-cyan-200 transition">
                        <div className="text-4xl mb-3">
                            📊
                        </div>
                        <h3 className="text-xl font-semibold text-blue-700 mb-2">
                            Market-Driven Insights
                        </h3>
                        <p className="text-gray-600">
                            Every recommendation is based on real-time Kenyan job market trends and emerging technical opportunities.
                        </p>
                    </div>
                    <div className="bg-white p-6 rounded-2xl shadow-md border border-gray-100 hover:shadow-blue-200 transition">
                        <div className="text-4xl mb-3">
                            ⚡
                        </div>
                        <h3 className="text-xl font-semibold text-blue-700 mb-2">
                            Discover Hidden Skills
                        </h3>
                        <p className="text-gray-600">
                            Upload your CV and instantly uncover skills you didn’t know you had — mapped directly to real job roles.
                        </p>
                    </div>
                    <div className="bg-white p-6 rounded-2xl shadow-md border border-gray-100 hover:shadow-cyan-200 transition">
                        <div className="text-4xl mb-3">
                            🚀
                        </div>
                        <h3 className="text-xl font-semibold text-blue-700 mb-2">
                            Smart Learning Paths
                        </h3>
                        <p className="text-gray-600">
                            Get auto-generated skill-building roadmaps tailored for the exact job you want.
                        </p>
                    </div>
                    <div className="bg-white p-6 rounded-2xl shadow-md border border-gray-100 hover:shadow-blue-200 transition">
                        <div className="text-4xl mb-3">
                            🤝
                        </div>
                        <h3 className="text-xl font-semibold text-blue-700 mb-2">
                            Built for Kenyan Youth
                        </h3>
                        <p className="text-gray-600">
                            Every insight is localized — no foreign job markets, no irrelevant data. 100% Kenya-focused.
                        </p>
                    </div>
                    <div className="bg-white p-6 rounded-2xl shadow-md border border-gray-100 hover:shadow-cyan-200 transition">
                        <div className="text-4xl mb-3">
                            📱
                        </div>
                        <h3 className="text-xl font-semibold text-blue-700 mb-2">
                            Mobile-First Experience
                        </h3>
                        <p className="text-gray-600">
                            Designed for accessibility — easy to use on any device,anywhere, anytime.
                        </p>
                    </div>
                </div>
            </div>
        </section>;
    }
}
