cl import from ..components.layout.Header { Header }
cl import from ..components.hero.Hero { Hero }
cl import from ..components.landing.ValueProposition { ValueProposition }
cl import from ..components.landing.Features { Features }
cl import from ..components.landing.HowItWorks { HowItWorks }
cl import from ..components.landing.Faq { FAQ }
cl import from ..components.layout.Footer { Footer }
cl {
    def HomePage()  -> any {
        return <div className="min-h-screen bg-gray-50 text-gray-900 font-sans">
            <Header />
            <Hero />
            <ValueProposition />
            <Features />
            <HowItWorks />
            <FAQ />
            <Footer />
        </div>;
    }
}
