cl {
    def JobOpportunities(props: any) -> any {
        job_postings = props["job_postings"] or [];

        if job_postings.length == 0 {
            return <div className="card fade-in">
                <h3 className="font-semibold mb-4 text-gray-800">
                    Job Opportunities
                </h3>
                <p className="text-sm text-gray-500">
                    No job opportunities found at the moment. Please check back later.
                </p>
            </div>;
        }

        return <div className="card fade-in">
            <h3 className="font-semibold mb-4 text-gray-800">
                Job Opportunities
            </h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                {job_postings.map(
                    lambda  job: any  -> any{ return <div className="card border border-gray-200 hover:shadow-lg transition-shadow p-4 fade-in">
                        <p className="font-semibold text-primary-500">
                            {job["title"]}
                        </p>
                        <p className="text-sm text-gray-600">
                            {job["company"]}
                        </p>
                        <p className="text-xs text-gray-500">
                            {job["location"]}
                        </p>
                    </div>; }
                )}
            </div>
        </div>;
    }
}
