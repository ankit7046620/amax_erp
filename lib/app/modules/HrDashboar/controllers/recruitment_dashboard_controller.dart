import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecruitmentDashboardController extends GetxController {
  // Observable variables for dashboard stats
  var isLoading = true.obs;
  var totalJobOpenings = 0.obs;
  var totalApplicantsThisMonth = 0.obs;
  var acceptedJobApplicants = 0.obs;
  var rejectedJobApplicants = 0.obs;
  var jobOfferThisMonth = 0.obs;
  var newCandidateAddedThisMonth = 0.obs;
  var jobOfferAcceptanceRate = 0.obs;
  var timeToFill = 14.obs; // Default value

  // Chart data
  var jobApplicantPipelineData = <JobApplicantPipelineData>[].obs;
  var jobApplicantSourceData = <JobApplicantSourceData>[].obs;
  var jobApplicantsByCountryData = <JobApplicantsByCountryData>[].obs;
  var jobApplicationStatusData = <JobApplicationStatusData>[].obs;
  var jobOfferStatusData = <JobOfferStatusData>[].obs;
  var interviewStatusData = <InterviewStatusData>[].obs;
  var jobApplicationFrequencyData = <JobApplicationFrequencyData>[].obs;

  final String apiUrl = 'https://plastic.techcloudamax.ai/api/resource/Job%20Applicant?fields=["*"]';
  final String cookie = 'sid=3d1a53c2caf7cfdc889e2f47e0bbcc81fe3454835c7386a2995c8860; full_name=Vignesh; sid=3d1a53c2caf7cfdc889e2f47e0bbcc81fe3454835c7386a2995c8860; system_user=yes; user_id=vignesh%40amaxconsultancyservices.com; user_image=';

  @override
  void onInit() {
    super.onInit();
    fetchJobApplicantData();
  }

  Future<void> fetchJobApplicantData() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Cookie': cookie,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> jobApplicants = data['data'] ?? [];

        processJobApplicantData(jobApplicants);
      } else {
        Get.snackbar('Error', 'Failed to fetch job applicant data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void processJobApplicantData(List<dynamic> jobApplicants) {
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    // Calculate basic stats
  //  totalJobOpenings.value = jobApplicants.map((app) => app['job_title']).where((title) => title != null && title.toString().isNotEmpty).toSet().length;
    totalJobOpenings.value = jobApplicants.where((app) => app['status'] == 'Open').length;
    // Total applicants this month
    totalApplicantsThisMonth.value = jobApplicants.where((app) {
      if (app['creation'] != null) {
        try {
          final creationDate = DateTime.parse(app['creation']);
          return creationDate.month == currentMonth && creationDate.year == currentYear;
        } catch (e) {
          return false;
        }
      }
      return false;
    }).length;

    // Accepted and Rejected applicants
    acceptedJobApplicants.value = jobApplicants.where((app) => app['status'] == 'Accepted').length;
    rejectedJobApplicants.value = jobApplicants.where((app) => app['status'] == 'Rejected').length;

    // Job offers this month (assuming accepted status means job offer)
    jobOfferThisMonth.value = jobApplicants.where((app) {
      if (app['status'] == 'Accepted' && app['modified'] != null) {
        try {
          final modifiedDate = DateTime.parse(app['modified']);
          return modifiedDate.month == currentMonth && modifiedDate.year == currentYear;
        } catch (e) {
          return false;
        }
      }
      return false;
    }).length;

    // New candidates added this month
    newCandidateAddedThisMonth.value = totalApplicantsThisMonth.value;

    // Job offer acceptance rate
    final totalOffers = acceptedJobApplicants.value + rejectedJobApplicants.value;
    if (totalOffers > 0) {
      jobOfferAcceptanceRate.value = ((acceptedJobApplicants.value / totalOffers) * 100).round();
    } else {
      jobOfferAcceptanceRate.value = 0;
    }

    // Process all chart data
    processJobApplicantPipelineData(jobApplicants);
    processJobApplicantSourceData(jobApplicants);
    processJobApplicantsByCountryData(jobApplicants);
    processJobApplicationStatusData(jobApplicants);
    processJobOfferStatusData(jobApplicants);
    processInterviewStatusData(jobApplicants);
    processJobApplicationFrequencyData(jobApplicants);
  }

  void processJobApplicantPipelineData(List<dynamic> jobApplicants) {
    // Sample pipeline data based on job titles
    Map<String, int> pipelineCounts = {};

    for (var applicant in jobApplicants) {
      final jobTitle = applicant['job_title'] ?? 'General Position';
      pipelineCounts[jobTitle] = (pipelineCounts[jobTitle] ?? 0) + 1;
    }

    List<JobApplicantPipelineData> pipelineData = [];
    int index = 0;
    for (var entry in pipelineCounts.entries) {
      if (index < 5) { // Limit to top 5 positions
        pipelineData.add(JobApplicantPipelineData(entry.key, entry.value));
        index++;
      }
    }

    jobApplicantPipelineData.value = pipelineData;
  }

  void processJobApplicantSourceData(List<dynamic> jobApplicants) {
    Map<String, int> sourceCounts = {};

    for (var applicant in jobApplicants) {
      final source = applicant['source'] ?? 'Direct Application';
      sourceCounts[source] = (sourceCounts[source] ?? 0) + 1;
    }

    jobApplicantSourceData.value = sourceCounts.entries
        .map((e) => JobApplicantSourceData(e.key, e.value))
        .toList();
  }

  void processJobApplicantsByCountryData(List<dynamic> jobApplicants) {
    Map<String, int> countryCounts = {};

    for (var applicant in jobApplicants) {
      final country = applicant['country'] ?? 'Unknown';
      countryCounts[country] = (countryCounts[country] ?? 0) + 1;
    }

    jobApplicantsByCountryData.value = countryCounts.entries
        .map((e) => JobApplicantsByCountryData(e.key, e.value))
        .toList();
  }

  void processJobApplicationStatusData(List<dynamic> jobApplicants) {
    Map<String, int> statusCounts = {};

    for (var applicant in jobApplicants) {
      final status = applicant['status'] ?? 'Open';
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }

    jobApplicationStatusData.value = statusCounts.entries
        .map((e) => JobApplicationStatusData(e.key, e.value))
        .toList();
  }

  void processJobOfferStatusData(List<dynamic> jobApplicants) {
    Map<String, int> offerStatusCounts = {};

    for (var applicant in jobApplicants) {
      final status = applicant['status'];
      if (status == 'Accepted') {
        offerStatusCounts['Accepted'] = (offerStatusCounts['Accepted'] ?? 0) + 1;
      } else if (status == 'Rejected') {
        offerStatusCounts['Rejected'] = (offerStatusCounts['Rejected'] ?? 0) + 1;
      }
    }

    jobOfferStatusData.value = offerStatusCounts.entries
        .map((e) => JobOfferStatusData(e.key, e.value))
        .toList();
  }

  void processInterviewStatusData(List<dynamic> jobApplicants) {
    // Since we don't have interview status in the current data,
    // we'll create sample data based on application status
    Map<String, int> interviewStatusCounts = {'Cleared': 0};

    // Assuming accepted applicants have cleared interviews
    interviewStatusCounts['Cleared'] = jobApplicants.where((app) => app['status'] == 'Accepted').length;

    interviewStatusData.value = interviewStatusCounts.entries
        .where((entry) => entry.value > 0)
        .map((e) => InterviewStatusData(e.key, e.value))
        .toList();
  }

  void processJobApplicationFrequencyData(List<dynamic> jobApplicants) {
    Map<String, int> monthlyApplications = {};

    // Get last 6 months
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthName = _getMonthName(month.month);
      monthlyApplications[monthName] = 0;
    }

    for (var applicant in jobApplicants) {
      if (applicant['creation'] != null) {
        try {
          final creationDate = DateTime.parse(applicant['creation']);
          final monthName = _getMonthName(creationDate.month);
          if (monthlyApplications.containsKey(monthName)) {
            monthlyApplications[monthName] = monthlyApplications[monthName]! + 1;
          }
        } catch (e) {
          // Handle invalid date format
        }
      }
    }

    jobApplicationFrequencyData.value = monthlyApplications.entries
        .map((e) => JobApplicationFrequencyData(e.key, e.value))
        .toList();
  }

  String _getMonthName(int month) {
    const monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month];
  }

  Future<void> refreshData() async {
    await fetchJobApplicantData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

// Data models for charts
class JobApplicantPipelineData {
  final String jobTitle;
  final int count;

  JobApplicantPipelineData(this.jobTitle, this.count);
}

class JobApplicantSourceData {
  final String source;
  final int count;

  JobApplicantSourceData(this.source, this.count);
}

class JobApplicantsByCountryData {
  final String country;
  final int count;

  JobApplicantsByCountryData(this.country, this.count);
}

class JobApplicationStatusData {
  final String status;
  final int count;

  JobApplicationStatusData(this.status, this.count);
}

class JobOfferStatusData {
  final String status;
  final int count;

  JobOfferStatusData(this.status, this.count);
}

class InterviewStatusData {
  final String status;
  final int count;

  InterviewStatusData(this.status, this.count);
}

class JobApplicationFrequencyData {
  final String month;
  final int count;

  JobApplicationFrequencyData(this.month, this.count);
}