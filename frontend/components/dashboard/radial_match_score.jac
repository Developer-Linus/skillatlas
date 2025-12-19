cl {
    def RadialMatchScore(props: dict) -> any {
        score = props.get("score", 0);

        return <div className="flex flex-col items-center gap-2 my-4">
            <div className="relative w-32 h-32 rounded-full bg-gradient-to-r from-blue-500 via-teal-400 to-cyan-400 flex items-center justify-center">
                <div className="w-24 h-24 bg-white rounded-full flex items-center justify-center">
                    <span className="text-2xl font-bold text-blue-600">
                        {score}%
                    </span>
                </div>
            </div>
            <p className="text-sm text-gray-600">
                Role Match Score
            </p>
        </div>;
    }
}
