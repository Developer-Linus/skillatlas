cl import from ..components.layout.Header { Header }
cl import from ..components.hero.Hero { Hero }

cl {
    def HomePage()  -> any {
        return <div className="min-h-screen bg-gray-50 text-gray-900 font-sans">
            <Header />
            <Hero />
            <main className="p-4 max-w-7xl mx-auto">
                <h1 className="text-3xl text-blue-500 font-bold mb-4">
                    Welcome to SkillAtlas
                </h1>
                <p className="text-gray-700">
                    Your smart career path navigator is now ready.
                </p>
            </main>
        </div>;
    }
}
