import 'package:flutter/material.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});
  

  @override
  Widget build(BuildContext context) {
    
    return  SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Text(
              "Sammy Thorne",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Software Engineer • Sammy@dev-crypt.com • (360) 784-9142",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 30, thickness: 2),
      
            // Summary
            Text(
              "Summary",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enthusiastic developer with experience in full stack development with Flutter, applied secuirty and "
              "Encryption algorithms. Dedicated to using technical skills to improve saftey of tech for the genral public.\n"
              " enamored with security design, deployment and practice ",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
      
            // Experience
            Text(
              "Experience",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            _experienceItem(
              title: "Webhosting admin",
              company: "Techmint Applied Solutions",
              years: "Feb 2025 - July 2025",
              description:
                  "• Fostered teamwork by training peers on web development frameworks, enhancing overall team efficency and knowledge sharing.\n"
                  "• Maintained comprehensive documentation of web hosting process, ensuring clarity and adherence to best practices across projects.\n"
                  "• Coordinated cross functional teams to address clients needs promptly, fostering a culture of shared responsibility and customer satisfaction.",
            ),
            const SizedBox(height: 15),
            _experienceItem(
              title: "Extern",
              company: "Washington State University",
              years: "Sep 2024 - Jan 2025",
              description:
                  "• Understudied proffesor while fixing and improving WSU auto lab system used for automated grading in 10+ CS courses\n"
                  "• Learned many full stack development skills such as Ruby on Rails, git and Docker.\n"
                  "• Observed technical improvments and best practices in system maintenence, ensuring calrity for future team members",
            ),
            const SizedBox(height: 20),
            _experienceItem(
              title: "Crew Trainer",
              company: "North Star resturants",
              years: "Aug 2021 - Oct 2024",
              description:
                  "• provided coaching and mentorship to foster a positive work enviornment amount staff members\n"
                  "• Explained training information in easy and understandable terms for individuals from all backgrounds and levels\n"
                  "• Observed technical improvments and best practices in system maintenence, ensuring calrity for future team members",
            ),
            // Education
            Text(
              "Education",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            const Text("B.S. in Computer Science — Washington State University ( Aug 2021 - Jun 2026)"),
            const SizedBox(height: 20),
      
            // Skills
            Text(
              "Skills",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                Chip(label: Text("Flutter/Dart")),
                Chip(label: Text("Python")),
                Chip(label: Text("Go")),
                Chip(label: Text("Rust")),
                Chip(label: Text("C/C++")),
                Chip(label: Text("Git")),
                Chip(label: Text("Encryption algorithms")),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Refrences",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Column(
                children: [
                  Text("Mario Mints",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("Direct Manager at Techmint"),
                  Text("mac@techmint.com"),
                  Text("(206)-602-07259")
                ],
              ),
              const SizedBox(width: 45),
            Column(
              children: [
                Text("Renee Media",style: TextStyle(fontWeight: FontWeight.bold)),
                Text("General Manager at North Star"),
                Text("(360)-977-2440")
            ],)
            ],
            
            )
          ],
        ),
      );
  }

  Widget _experienceItem({
    required String title,
    required String company,
    required String years,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$title — $company",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(years, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Text(description),
      ],
    );
  }
}
