cl import from react { useState }

cl {
    def ValueProposition()  -> any {
        return <section className="bg-white py-16 px-4 sm:py-20 sm:px-6">
            <div className="max-w-5xl mx-auto text-center flex flex-col gap-6">
                <h2 className="section-heading text-3xl sm:text-4xl md:text-5xl text-blue-600 font-bold">
                    Unlock Your True Career Path
                </h2>
                <p className="text-base sm:text-lg md:text-xl text-gray-700 max-w-3xl mx-auto">
                    Many youths in Kenya struggle to know which career direction to take. Others already have valuable skills they’re not even aware of. Our platform makes this simple.
                </p>
                <p className="text-base sm:text-lg md:text-xl text-gray-700 max-w-3xl mx-auto">
                    With smart, AI-driven recommendations powered by real market trends in technical fields, you’ll instantly discover:
                </p>
                <ul className="list-disc list-inside text-gray-700 max-w-lg mx-auto space-y-3 text-left text-base sm:text-lg">
                    <li>
                        <strong>
                            Your hidden skills
                        </strong>
                    </li>
                    <li>
                        <strong>
                            Careers you naturally fit into
                        </strong>
                    </li>
                    <li>
                        <strong>
                            Skills you need to grow
                        </strong>
                    </li>
                    <li>
                        <strong>
                            Opportunities shaping Kenya’s job market right now
                        </strong>
                    </li>
                </ul>
                <p className="text-base sm:text-lg md:text-xl text-gray-700 max-w-3xl mx-auto font-semibold">
                    No confusion. No guesswork. Just clarity — backed by data.
                </p>
                <div className="flex justify-center">
                    <a
                        href="/signup"
                        className="px-8 py-3 font-semibold rounded-full text-white text-lg bg-blue-600 border-2 border-transparent hover:border-cyan-400 hover:bg-gradient-to-r from-blue-500 via-teal-400 to-cyan-400 transition-all duration-300 shadow-lg hover:shadow-cyan-400/50"
                    >
                        Get Started
                    </a>
                </div>
            </div>
        </section>;
    }
}
