cl import from react { useState }

cl {
    def HowItWorks()  -> any {
        return <section className="bg-white py-16 px-4 sm:py-20 sm:px-6">
            <div className="max-w-7xl mx-auto flex flex-col gap-10">
                <h2 className="text-center text-3xl sm:text-4xl font-bold text-blue-600">
                    How SkillAtlas Works
                </h2>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div className="bg-gray-50 p-8 rounded-2xl shadow-md border border-gray-100 hover:shadow-blue-200 transition text-center">
                        <div className="text-5xl mb-4">
                            📤
                        </div>
                        <h3 className="text-xl font-semibold text-blue-700 mb-2">
                            1. Upload Your CV
                        </h3>
                        <p className="text-gray-600">
                            Our AI scans your CV to extract skills, strengths, and hidden abilities you may not even know you have.
                        </p>
                    </div>
                    <div className="bg-gray-50 p-8 rounded-2xl shadow-md border border-gray-100 hover:shadow-cyan-200 transition text-center">
                        <div className="text-5xl mb-4">
                            🔍
                        </div>
                        <h3 className="text-xl font-semibold text-blue-700 mb-2">
                            2. Get Your Personalized Insights
                        </h3>
                        <p className="text-gray-600">
                            Instantly receive smart recommendations based on your skills and Kenya’s real job-market trends.
                        </p>
                    </div>
                    <div className="bg-gray-50 p-8 rounded-2xl shadow-md border border-gray-100 hover:shadow-blue-200 transition text-center">
                        <div className="text-5xl mb-4">
                            🚀
                        </div>
                        <h3 className="text-xl font-semibold text-blue-700 mb-2">
                            3. Follow Your Career Path
                        </h3>
                        <p className="text-gray-600">
                            Access learning paths, required skills, and role-based guidance to confidently pursue your ideal career.
                        </p>
                    </div>
                </div>
            </div>
        </section>;
    }
}
