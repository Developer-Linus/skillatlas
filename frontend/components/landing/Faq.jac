cl import from react { useState }

cl {
    def FAQ()  -> any {
        let faqs = [
            {
                id: 1,
                q: "How does SkillAtlas determine my career path?",
                a: "Our AI analyzes the skills in your CV, compares them with real job market data in Kenya, and generates personalized recommendations backed by trends."
            },
            {
                id: 2,
                q: "Do I need a CV to get started?",
                a: "A CV gives the most accurate results, but you can also enter your skills manually and still receive useful insights."
            },
            {
                id: 3,
                q: "Is SkillAtlas free to use?",
                a: "Yes, the core features—CV analysis, skill detection, and career suggestions—are completely free for Kenyan youth."
            },
            {
                id: 4,
                q: "What makes SkillAtlas different from other platforms?",
                a: "SkillAtlas focuses fully on Kenya’s job market, ensuring every insight, skill path, and recommendation is accurate and locally relevant."
            },
            {
                id: 5,
                q: "Will my data remain private?",
                a: "Absolutely. Your CV and personal information are processed securely and never shared with third parties."
            }
        ];

        let [openIndex, setOpenIndex] = useState(-1);

        def handleToggle(current: int, index: int) -> int {
            if current == index {
                return -1;
            } else {
                return index;
            }
        }

        def iconFor(isOpen: bool) -> str {
            if isOpen {
                return "-";
            } else {
                return "+";
            }
        }

        def answerFor(isOpen: bool, text: str) -> any {
            if isOpen {
                return <p className="mt-3 text-gray-600 text-base leading-relaxed">
                    {text}
                </p>;
            } else {
                return <div></div>;
            }
        }

        return <section className="bg-white py-16 px-4 sm:py-20 sm:px-6">
            <div className="max-w-5xl mx-auto flex flex-col gap-8">
                <h2 className="text-center text-3xl sm:text-4xl font-bold text-blue-600">
                    Frequently Asked Questions
                </h2>
                <div className="flex flex-col gap-4">
                    {faqs.map(
                        lambda  item: any  -> any{ let isOpen = openIndex == item.id;return <div
                            key={item.id}
                            className="bg-gray-50 rounded-xl border border-gray-200 shadow-sm p-5 sm:p-6 transition hover:shadow-blue-200 cursor-pointer"
                            onClick={lambda  _: any  -> any{ setOpenIndex(
                                handleToggle(openIndex, item.id)
                            );} }
                        >
                            <div className="flex justify-between items-center">
                                <h3 className="text-lg sm:text-xl font-semibold text-blue-700">
                                    {item.q}
                                </h3>
                                <span className="text-2xl font-bold text-blue-600">
                                    {iconFor(isOpen)}
                                </span>
                            </div>
                            {answerFor(isOpen, item.a)}
                        </div>; }
                    )}
                </div>
            </div>
        </section>;
    }
}
