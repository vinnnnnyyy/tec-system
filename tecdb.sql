-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 29, 2025 at 06:51 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tecdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add program', 7, 'add_program'),
(26, 'Can change program', 7, 'change_program'),
(27, 'Can delete program', 7, 'delete_program'),
(28, 'Can view program', 7, 'view_program'),
(29, 'Can add appointment', 8, 'add_appointment'),
(30, 'Can change appointment', 8, 'change_appointment'),
(31, 'Can delete appointment', 8, 'delete_appointment'),
(32, 'Can view appointment', 8, 'view_appointment'),
(33, 'Can add FAQ', 9, 'add_faq'),
(34, 'Can change FAQ', 9, 'change_faq'),
(35, 'Can delete FAQ', 9, 'delete_faq'),
(36, 'Can view FAQ', 9, 'view_faq'),
(37, 'Can add exam score', 10, 'add_examscore'),
(38, 'Can change exam score', 10, 'change_examscore'),
(39, 'Can delete exam score', 10, 'delete_examscore'),
(40, 'Can view exam score', 10, 'view_examscore'),
(41, 'Can add exam result', 11, 'add_examresult'),
(42, 'Can change exam result', 11, 'change_examresult'),
(43, 'Can delete exam result', 11, 'delete_examresult'),
(44, 'Can view exam result', 11, 'view_examresult'),
(45, 'Can add test center', 12, 'add_testcenter'),
(46, 'Can change test center', 12, 'change_testcenter'),
(47, 'Can delete test center', 12, 'delete_testcenter'),
(48, 'Can view test center', 12, 'view_testcenter'),
(49, 'Can add test room', 13, 'add_testroom'),
(50, 'Can change test room', 13, 'change_testroom'),
(51, 'Can delete test room', 13, 'delete_testroom'),
(52, 'Can view test room', 13, 'view_testroom'),
(53, 'Can add test session', 14, 'add_testsession'),
(54, 'Can change test session', 14, 'change_testsession'),
(55, 'Can delete test session', 14, 'delete_testsession'),
(56, 'Can view test session', 14, 'view_testsession'),
(57, 'Can add announcement', 15, 'add_announcement'),
(58, 'Can change announcement', 15, 'change_announcement'),
(59, 'Can delete announcement', 15, 'delete_announcement'),
(60, 'Can view announcement', 15, 'view_announcement'),
(61, 'Can add otp verification', 16, 'add_otpverification'),
(62, 'Can change otp verification', 16, 'change_otpverification'),
(63, 'Can delete otp verification', 16, 'delete_otpverification'),
(64, 'Can view otp verification', 16, 'view_otpverification');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(3, 'pbkdf2_sha256$870000$ZW00G8n0xs64agEjEflA6S$3yT+YO6fP4il6hES8N9Ll+oetJa0H28z32ZoGlZPAJA=', NULL, 0, 'james@gmail.com', 'Lebron', 'james', 'james@gmail.com', 1, 1, '2025-03-11 17:57:49.930888'),
(4, 'pbkdf2_sha256$870000$b0EGlSrJdbky6qQEjq3j3Q$Y6rlTr927wbZn8uGs7yh2Pao1euZ2i8yXzWi5HpMe9g=', NULL, 0, 'yes@gmail.com', 'printer', 'lakuping', 'yes@gmail.com', 0, 1, '2025-03-11 18:17:43.887405'),
(16, 'pbkdf2_sha256$870000$eoNNucKB3g9Zt1BzYNS6Zs$NdTj/IsmSa3DV8NQVHr4eyW4B9Qp6rZjUBj7YMontNo=', NULL, 0, 'step@gmail.com', 'curry', 'step', 'step@gmail.com', 0, 1, '2025-03-12 11:17:35.676298'),
(17, 'pbkdf2_sha256$870000$pSE8Di1iSKltXcxqCb0DVp$+hUzaaOpY9VNMqftYrtcedEVyQVn1xqfRyLg1WHFK0k=', NULL, 0, 'vim@gmail.com', 'zet', 'vim', 'vim@gmail.com', 0, 1, '2025-03-12 12:10:20.866762'),
(18, 'pbkdf2_sha256$870000$SYSXnbjaAToQkNDgxl3Cy7$T92dzVVJ4ewY9rEGbf6EXLJrfu5AixqTvaJL4N+vjOo=', NULL, 0, 'mail@gmail.com', 'cc', '101', 'mail@gmail.com', 0, 1, '2025-03-12 12:37:07.308158'),
(20, 'pbkdf2_sha256$870000$HGeX3tg2c1HiBZlopVQ1OJ$FuuFkJmM9MDsdGZqcbKnlXuja/xVEvsgBjZn7NXuFss=', NULL, 0, 'vebe@gmail.com', 'vennn', 'gsgh', 'vebe@gmail.com', 0, 1, '2025-03-12 13:32:44.619756'),
(21, 'pbkdf2_sha256$870000$xgenE9jx4XtoRKpjXT4WNf$vO35Ex+mpnncorv4aI8Z1RExQA/RcOcjMtNQoj50kfo=', NULL, 0, 'demo@gmail.com', 'demo', 'demo2', 'demo@gmail.com', 0, 1, '2025-03-12 13:42:47.264252'),
(22, 'pbkdf2_sha256$870000$3dzU5CgxEzwem6kiQrla5H$TJCzpTzYADz//9gw8ytXUFs5GGKxwKEeM4P4gCo6tq8=', NULL, 0, 'dem@gmail.com', 'dem', 'dem', 'dem@gmail.com', 0, 1, '2025-03-12 13:58:49.382177'),
(23, 'pbkdf2_sha256$870000$xfAsZSXpsc4FNFmP217LEP$s8j6fNvR4/txv/Vc2qqZyoiONRuSkhmOKZrK7axDWBA=', NULL, 0, 'demoo@gmail.com', 'demoo', 'demoo', 'demoo@gmail.com', 0, 1, '2025-03-12 14:02:32.233308'),
(25, 'pbkdf2_sha256$870000$BMdSkDTEYUoszjzzp9RywJ$nGsUiAXBFHMqdIuvJcycWz8J0++GQ/Fn3INeQdrL8H4=', NULL, 0, 'boss@gmail.com', 'boss', 'final', 'boss@gmail.com', 0, 1, '2025-03-12 14:14:09.858189'),
(26, 'pbkdf2_sha256$870000$PsaLUIVJcLtA1L0ZFZNevg$L/FVkni/O8cMZTVT8XBmJDbbHBvPTLF8bhoz33OLTrs=', NULL, 0, 'vanlo@gmail.com', 'van', 'lo', 'vanlo@gmail.com', 0, 1, '2025-03-12 14:15:48.156170'),
(27, 'pbkdf2_sha256$870000$KWniRlI11L38QF7rzKxpZi$d0pw3vJZEDZeydtlreqzd4iGI7SAD2sYk04l5yDmhTk=', NULL, 0, 'fran@gmail.com', 'cis', 'fran', 'fran@gmail.com', 0, 1, '2025-03-13 00:04:26.276361'),
(28, 'pbkdf2_sha256$870000$OjALuh2RlJeZSAr4WRRbYM$k8e1RKC2dVEbxIP2gtNhlVx3+Ok/UfkzamJ4bwi8GDI=', NULL, 0, 'manong@gmail.com', 'manong', 'jun', 'manong@gmail.com', 0, 1, '2025-03-13 12:45:49.802516'),
(30, 'pbkdf2_sha256$870000$ofLc2ruMKhSbbmppzgulA7$WrO2u3Y8B8mk9tkppoacbVRj8uh1G3KSOcuHT3P90F0=', NULL, 0, 'alken@gmail.com', 'alken', 'james', 'alken@gmail.com', 0, 1, '2025-03-14 00:17:44.933078'),
(31, 'pbkdf2_sha256$870000$Ix1FFjzxIDcNFbrQd1etM8$tGgQcWAj2fKbgo+ycLN9ctP4NIBBS0FMM/doUgC2Ztw=', NULL, 0, 'camlian@gmail.com', 'Sef', 'Camlian', 'camlian@gmail.com', 0, 1, '2025-03-14 01:19:05.856381'),
(32, 'pbkdf2_sha256$870000$fhZB2MKgk0gVesvoN9ywIq$/9IfTM7yj7pFwplUthDAHTBlgC+/fe3qSmffrOki2gY=', NULL, 0, 'h@gmail.com', 'shghsgd', 'sggsd', 'h@gmail.com', 0, 1, '2025-03-15 10:40:27.223641'),
(33, 'pbkdf2_sha256$870000$8aCojbIXLdOPalXsr4be7I$ni2ct4G79tNq79RnHV+AUk4/X4GjIEB2YyIYPpU/ujM=', NULL, 0, 'd@gmail.com', 'd', 'd', 'd@gmail.com', 0, 1, '2025-03-15 14:32:53.320936'),
(34, 'pbkdf2_sha256$870000$4NhoSgp5I2THzfFNhv1Ogi$ykdIvtO8wxoSZxbZpAhkC6GF5jTo7JL3xpwgv7qnPQE=', NULL, 0, 'a@gmail.com', 'a', 'a', 'a@gmail.com', 0, 1, '2025-03-15 14:34:45.962035'),
(35, 'pbkdf2_sha256$870000$wBJI1WiljHXPJpR8RdVu1h$Zamx2GV2fDfCkY8uY3FtaYc9X3eQH+zE16NaH32iwzE=', NULL, 0, 'r@gmail.com', 'r', 'r', 'r@gmail.com', 0, 1, '2025-03-15 14:36:04.978129'),
(36, 'pbkdf2_sha256$870000$jFBEDtsfKWakc6gfcSHfHV$Z1tJb9PawSQOJLbWNlHen20ZJpaz1DJP/JAD4FP8tsg=', NULL, 0, 's@gmail.com', 's', 's', 's@gmail.com', 0, 1, '2025-03-15 14:48:13.926508'),
(37, 'pbkdf2_sha256$870000$w2wOJULSkGjmmKQO9dWqi3$AUrti2r8eND4hBnUn/mpzLAST2isb/OD0f8ZA6dLMKE=', NULL, 0, 'w@gmail.com', 'w', 'w', 'w@gmail.com', 0, 1, '2025-03-15 14:50:28.337830'),
(38, 'pbkdf2_sha256$870000$GIt9dpsoojXoz7cJNiaYri$uG1/LCdX6p5O8c35RzBHw/B89WuhczTZoEfPzzv+LK4=', NULL, 0, 'aa@gmail.com', 'aa', 'a', 'aa@gmail.com', 0, 1, '2025-03-15 15:11:22.829014'),
(39, 'pbkdf2_sha256$870000$4V66206JnHrAzA83y1RDIB$0aE7Y1bjKIB5QSiQ9oUbbUTyjxBXmpEfGAmKyQSVBEo=', NULL, 0, 'bb@gmail.com', 'bb', 'bb', 'bb@gmail.com', 0, 1, '2025-03-15 15:12:19.877414'),
(40, 'pbkdf2_sha256$870000$FUEWu8VqBuSZISVVfj01Qv$UY3X+hU8hkzoSDAGkC3BWbRROxwOoJFjHfRsGIOjj0s=', NULL, 0, 'g@gmail.com', 'gg', 'sjh', 'g@gmail.com', 0, 1, '2025-03-15 15:14:54.970846'),
(41, 'pbkdf2_sha256$870000$3woP7m39wLTtuGVoIkUsL4$YwRU4v+wcU1IVJNbS1lu+cpZqD0uTKaibTPIKSpPoL4=', NULL, 0, 'l@gmail.com', 'l', 'l', 'l@gmail.com', 0, 1, '2025-03-16 03:34:24.066454'),
(42, 'pbkdf2_sha256$870000$pBaXw834QHdWqAqRCWrq4Z$b3IFcr7iAozEBOfcgwjiUQ3AKrbS5ocHJQqyuyFSUZM=', NULL, 0, 'ddd@gmail.com', 'd', 'd', 'ddd@gmail.com', 0, 1, '2025-03-16 04:44:38.831921'),
(43, 'pbkdf2_sha256$870000$zLW98lKHs5Kq6GX5vbAAVv$oKU2GvGOHutndf4C00WtJjaIE3q8gQLyR+icR+z9wtA=', NULL, 0, 'kl@gmail.com', 'k', 'l', 'kl@gmail.com', 0, 1, '2025-03-16 08:12:32.606379'),
(44, 'pbkdf2_sha256$870000$jVpY2JahmAbnOz3fKyFmNm$SK/YdI/wNPTr2HsaKyHqvZ3g3RYN9/E0JPtmCCAD9nA=', NULL, 0, 'jd@gmail.com', 'jj', 'jj', 'jd@gmail.com', 0, 1, '2025-03-16 08:36:44.347469'),
(45, 'pbkdf2_sha256$870000$lQMpR80Snt1vq2bDkb5AJE$kEcs2smoKw3ppbb7kyyE7lLZUxhZjzBywyB9nKooPU0=', NULL, 0, 'abc@gmail.com', 'bbbb', 'abc', 'abc@gmail.com', 0, 1, '2025-03-16 08:42:59.433718'),
(48, 'pbkdf2_sha256$870000$aaCaBTz20KaiZe9oE7GMRD$MZ8VIgqQ13YQRwJS7ms/6cqpIYHWaBsOMiacFC7kfcI=', NULL, 0, 'gg@gmail.com', 'gg', 'gg', 'gg@gmail.com', 0, 1, '2025-03-16 12:39:32.550979'),
(49, 'pbkdf2_sha256$870000$6kaDo5dYjbSbFCQ2Wv800d$beql+/iK4D9/Ih15nkGbl21TlJdPjwzhzxOiJl9ilY8=', NULL, 0, 'zeno@gmail.com', 'kalv', 'zen', 'zeno@gmail.com', 0, 1, '2025-03-16 12:54:28.562889'),
(50, 'pbkdf2_sha256$870000$7FWLhkI0Zi0EUG0fo6WEJL$kGpmBc3Q0GcfrJjq1si1D9rcLf63ogLlqa2HqUR3cKM=', NULL, 0, 'dde@gmail.com', 'dhf', 'gdhhd', 'dde@gmail.com', 0, 1, '2025-03-16 13:21:37.661634'),
(54, 'pbkdf2_sha256$870000$i98oqakWpI2jcNowCqWXmR$f3c7VrgNTH9mUc9Fm+XLZyfsSyzB1iQmA/QQ7bwVL+U=', NULL, 0, 'kalvinnnnn@gmail.com', 'kalvin', 'lakuping', 'kalvinnnnn@gmail.com', 0, 1, '2025-03-18 15:32:12.511552'),
(55, 'pbkdf2_sha256$870000$7LyXG8ndQ2uUnJ11DTHJEK$sRvYkuGBCYVpTlaBh0WHdXcP5tXUZS3QgbbecuWSt0o=', NULL, 0, 'account@gmail.com', 'sample', 'account', 'account@gmail.com', 0, 1, '2025-03-19 05:39:38.986629'),
(56, 'pbkdf2_sha256$870000$vCEC1YApClEL5LWcaq35Ey$R2IxB4zxjWEzu8LWOkwCIOAAm8F4oryowAGDU4YlMuY=', NULL, 0, 'sdhgsy@gmail.com', 'shgdh', 'sjdyus', 'sdhgsy@gmail.com', 0, 1, '2025-03-20 22:53:38.750006'),
(57, 'pbkdf2_sha256$870000$cvJBkFa7g7afoclzQtg9w3$A3RBiRRiENukZq6lFDRCci05itP1e57Fy8hRy7Js5nY=', NULL, 0, 'shgh@gmail.com', 'jerj', 'bshs', 'shgh@gmail.com', 0, 1, '2025-03-20 23:03:10.344779'),
(58, 'pbkdf2_sha256$870000$wVQlxiKbjnq87lTi27vCMQ$lk8rAo+raiZolNQhZbxLnp3chJndbMAiHfFBO86Pau4=', NULL, 0, 'sgdf@gmail.com', 'jshdj', 'gdhsgd', 'sgdf@gmail.com', 0, 1, '2025-03-20 23:06:35.942019'),
(59, 'pbkdf2_sha256$870000$tsFx3JfRMwEWs98Gob50Xw$9EVY81APHrZQRR2m/2zf7C+YPRVTcno/eg7UVDqnxVA=', NULL, 0, 'sjdys@gmail.com', 'jwsyeu', 'jsydus', 'sjdys@gmail.com', 0, 1, '2025-03-21 12:59:37.878399'),
(60, 'pbkdf2_sha256$870000$jb4LWQtzG1dr3ek28gC9UD$/2FxcNB6aoWumjxH5cG1Zt88vkRPLQmqE4KR4ApPq9k=', NULL, 0, 'dddd@gmail.com', 'dhsgyd', 'hsgdys', 'dddd@gmail.com', 0, 1, '2025-03-21 13:06:11.260196'),
(61, 'pbkdf2_sha256$870000$4BK0EpOmGzK8QR8YeIn8RT$pBRVR6G+6ZEBrA6gKz/nfOyAvJ50pOuVkHiZtDBXV0U=', NULL, 0, 'sdghsd@gmail.com', 'sjhd', 'sjdhhj', 'sdghsd@gmail.com', 0, 1, '2025-03-21 14:47:37.280046'),
(62, 'pbkdf2_sha256$870000$k8pwjU8Tiyx3BMn0HvD0Qb$ZajIvrLbcl/+yOgOFWXEtj+ofAiO9thogvsg28O9ZQ8=', NULL, 0, 'sdhjd@gmail.com', 'djh', 'kdhjs', 'sdhjd@gmail.com', 0, 1, '2025-03-22 16:37:45.515188'),
(63, 'pbkdf2_sha256$870000$yOi80DA6C1NI9r86M7Y7us$UhhCVLGyg/RFJGTc4g9cVN2W17DE7M8RMLVYoE1/YeI=', NULL, 0, 'usyu@gmail.com', 'df', 'difi', 'usyu@gmail.com', 0, 1, '2025-03-22 16:41:47.068140'),
(64, 'pbkdf2_sha256$870000$uJMOY2BQsvmnAokiaYyk8t$02+nZP0eMCqTQZKhWComzkvQUh7MWKUvOb4Ok+LTC0o=', NULL, 0, 'sdhgsd@gmail.com', 'jshdj', 'shjdh', 'sdhgsd@gmail.com', 0, 1, '2025-03-22 17:24:18.717649'),
(65, 'pbkdf2_sha256$870000$2OGEh09WJXqPgFYBa6UP4R$S02glcZCH9/xnQ9qCknOiESzRJ0egU93L1Wbv0H6noc=', NULL, 0, 'sghd@gmail.com', 'd', 'sdhj', 'sghd@gmail.com', 0, 1, '2025-03-22 17:48:11.348069'),
(66, 'pbkdf2_sha256$870000$OXdl6d9IDPppkXL9NFcamq$uZ/mKJnAwobYo/Fo++p94gyNgdUcuIqqtNUFEoHZOyE=', NULL, 0, 'gsgg@gmail.com', 'shdj', 'dgf', 'gsgg@gmail.com', 0, 1, '2025-03-24 03:48:48.270603'),
(67, 'pbkdf2_sha256$870000$CMNCIrk346eOZbiuwb9QOA$AHpHyH2Gkwanv7JzXHsPic16sCnVldS5Qha2FWAxFck=', NULL, 0, 'sdhj@gmail.com', 'dhf', 'skdkjj', 'sdhj@gmail.com', 0, 1, '2025-03-24 03:57:26.527813'),
(68, 'pbkdf2_sha256$870000$fpYFJl9qtEDfGZ012LlLhf$zbYHRzgGWjGOlIo5i4UuLDwxGTBCh8tvN7K4DB6QB/8=', NULL, 0, 'jshduhu@gmail.com', 'sjdu', 'dsuyud', 'jshduhu@gmail.com', 0, 1, '2025-03-24 04:04:57.538435'),
(69, 'pbkdf2_sha256$870000$gooyl4uy93woM0jrGJq9ZX$ZvxDfHYnQRV51i3n/DDU9LjlpuKzdxtn5/SnMTFe5lA=', NULL, 0, 'sjdhjdsh@gmail.com', 'sdjhj', 'jdhhhd', 'sjdhjdsh@gmail.com', 0, 1, '2025-03-24 04:13:05.510242'),
(70, 'pbkdf2_sha256$870000$3VEcJ00gSXa1kpFbrmkhfq$5Gn/TZjgePTswV7k1KsHMrJ3CEyLFqXIe47WRyECgu8=', NULL, 0, 'oke@gmail.com', 'sha', 'oke', 'oke@gmail.com', 0, 1, '2025-03-24 07:12:55.147532'),
(71, 'pbkdf2_sha256$870000$oPrq3RDH92TnqsLefYPMtI$1tiCWv9/sKBN8/q1cVr9oS8Jyn2qTq099Bllrd0Z97U=', NULL, 0, 'student@gmail.com', 'student', 'sample', 'student@gmail.com', 0, 1, '2025-03-26 03:10:32.856168'),
(72, 'pbkdf2_sha256$870000$UZgArZt4N3sG2bR9lEIk7u$mBKwGZZyYve1+VHgsKPwsMNpulAFsaBzOY2kLv5pvlM=', NULL, 0, 'ceb@gmail.com', 'vin', 'lakuping', 'ceb@gmail.com', 0, 1, '2025-03-27 13:07:14.651076'),
(73, 'pbkdf2_sha256$870000$kPOJdBr0gVMkSNFyQ2q06L$v9w2x2qeNNc36FejmlmDnJScfnfopCGUt3hDWranFHE=', NULL, 0, 'ple@gmail.com', 'sam', 'ple', 'ple@gmail.com', 0, 1, '2025-03-28 00:14:50.336376'),
(74, 'pbkdf2_sha256$870000$z3VyjAdbqft56fCSRYRTFB$CAYH/ppMjJiHLtQrdviQArBpJOZyF+HpW7JSSXdmjSk=', NULL, 0, 'df@gmail.com', 'df', 'df', 'df@gmail.com', 0, 1, '2025-03-28 00:23:56.354468'),
(75, 'pbkdf2_sha256$870000$JbpND1hmmO0lTnAxHBRNL8$zwWeoJyLJhv85auFQ/h9uIs1R5bLyhsDxhpDCLv1t0o=', NULL, 0, 'sddhsdh@gmail.com', 'ddhgs', 'dhg', 'sddhsdh@gmail.com', 0, 1, '2025-03-28 00:26:51.689794'),
(76, 'pbkdf2_sha256$870000$VhbfJMDhbIUzkq1LUKeakp$G9aj7Mhk5KsvgQT/eUrN4pLWyxl37aAwur1I3Lny1vU=', NULL, 0, 'sdgsg@gmail.com', 'dhu', 'sdyus', 'sdgsg@gmail.com', 0, 1, '2025-03-30 09:25:23.486687'),
(77, 'pbkdf2_sha256$870000$lhN1wAKLKBL74hBIPUSfod$pqnzk7ulGikZLR25h0IWlC3Fmk3khDCky95AIe+kYMo=', NULL, 0, 'sjhdu@gmail.com', 'sdsiidu', 'iwi', 'sjhdu@gmail.com', 0, 1, '2025-04-01 11:08:52.804012'),
(78, 'pbkdf2_sha256$870000$pF6i7oIOz2UwEa4eqFEUpn$OMFW4ukdBiV6cDpQ6BTgH4NY3jIZDj6xF4kexinz+F4=', NULL, 0, 'data@gmail.com', 'data', 'data', 'data@gmail.com', 0, 1, '2025-04-02 06:14:46.703536'),
(79, 'pbkdf2_sha256$870000$VVx9BJBXTSHO6znJHhvVlb$N7yP+xAnzcIl8SYAUt4m4xN1Lo5r+LrCz7pTtR8M12g=', NULL, 0, 'hakdog@gmail.com', 'hakdog', 'hakdogin', 'hakdog@gmail.com', 0, 1, '2025-04-02 06:43:21.740068'),
(80, 'pbkdf2_sha256$870000$Ad1Vq1kZauWVlUzfWzLn8Y$BMC8xULTJ756Luww1UhsslcW+01pNO9OSFJC9mNEWQ0=', NULL, 0, 'hahaha@gmail.com', 'naggastos', 'ng hatdog', 'hahaha@gmail.com', 0, 1, '2025-04-02 06:47:11.868089'),
(81, 'pbkdf2_sha256$870000$xsDD096cdZLfed0hKOXV1N$4Nss/26nETx6lpKuX4113rPH5u9bFN0wcpYPE+LNCLI=', NULL, 0, 'rj@gmail.com', 'Rj', 'Toribio', 'rj@gmail.com', 0, 1, '2025-04-02 09:48:01.967025'),
(82, 'pbkdf2_sha256$870000$SWlXDWiJRrpnJPPCpIpcim$XfMNpgAM8bHKDQXPgvsicyFrKrf0+uObknKsJXQdx20=', NULL, 0, 'lakuping@gmail.com', 'user', 'vin', 'lakuping@gmail.com', 0, 1, '2025-04-07 08:46:34.310057'),
(87, 'pbkdf2_sha256$870000$v0uYUKB7h8SlLWxiKFaoTs$QGaadJyQCPJNfCWhCm/d+XVlHmJXjLXGqc9a8A/MDQE=', NULL, 0, 'aa22@gmail.com', 'rehh', 'aaa', 'aa22@gmail.com', 0, 1, '2025-04-07 08:56:09.017354'),
(88, 'pbkdf2_sha256$870000$OHI9U765PyOZhOoABwMTNx$f6NqaAX8hlo/S54xNxlFAQsdiJpLdLIkmhh7S3Gw8Ck=', NULL, 0, '222222@gmail.com', 'hhh', 'hhh', '222222@gmail.com', 0, 1, '2025-04-07 09:08:49.822956'),
(89, 'pbkdf2_sha256$870000$FhUZXf7fN7lEcFsWm2nY1c$nkppn6RnzfvtK6FOblmtE1w6Y2xOyrRj3ic2sQ2w9Ag=', NULL, 0, 'xt202000397@wmsu.edu.ph', 'Kalvin', 'lakuping', 'xt202000397@wmsu.edu.ph', 0, 1, '2025-04-07 09:13:52.669976'),
(90, 'pbkdf2_sha256$870000$4WxkxpKIzpZOOpTuS1pCrz$daOLJdvq5fo45/E38iag0Hx3/kMeb6NQDAjxnmvqLp0=', NULL, 0, 'jing@gmail.com', 'jin', 'mooo', 'jing@gmail.com', 0, 1, '2025-04-07 09:35:31.003759'),
(92, 'pbkdf2_sha256$870000$x7Jhmrvlh50DQtQHvTTFI7$0VQRuC9g13zczNnzxHcFmjZY2Z+qrmdy5r97f9VGrgw=', NULL, 0, 'jjjjj@gmail.com', 'hhh', 'hhh', 'jjjjj@gmail.com', 0, 1, '2025-04-07 12:33:47.419063'),
(93, 'pbkdf2_sha256$870000$S2A0cHFvaWpSYHN26RHmZD$BX8pifrejrrUjg4xLUFlMweSUUpjeQjUdOF/AmAnaIc=', NULL, 0, 'vvvv@gmail.com', 'Al', 'vu', 'vvvv@gmail.com', 0, 1, '2025-04-07 12:55:36.115000'),
(94, 'pbkdf2_sha256$870000$Za87rOHeSlZh38DM4az6fB$SRT5/Zkm+GXnCPsghj9WakyrrTZv217fE7bpb6cTzCo=', NULL, 0, 'boiiii@gmail.com', 'kulas', 'bi', 'boiiii@gmail.com', 0, 1, '2025-04-07 13:07:51.342047'),
(95, 'pbkdf2_sha256$870000$4p41aTvDRsKNXdTEgwMdu1$5g/oCu9B/XgyfYQcVPaSkKOpOXDdUqPchv53sWwxw4k=', NULL, 0, 'shdgsdh@gmail.com', 'ooooooo', 'ooo', 'shdgsdh@gmail.com', 0, 1, '2025-04-07 13:33:59.532251'),
(96, 'pbkdf2_sha256$870000$Hfn2vmVXvIIvBhfhMwV7iI$SRMRnJdKBxKUI6V8Hhf6nnrzyAPwxrpJ1P6UABvIPpc=', NULL, 0, 'fggg@gmail.com', 'hhhhh', 'iwi', 'fggg@gmail.com', 0, 1, '2025-04-07 19:52:10.813213'),
(97, 'pbkdf2_sha256$870000$TzPEiM3E81mqLkR5wWQd1o$wY30K7zgTVpsh+Yn8Szgm7/xZGa8J4WhmJQOGs6OrG8=', NULL, 0, 'sjdhuhsduh@gmail.com', 'dfjhjhd', 'sjdjh', 'sjdhuhsduh@gmail.com', 0, 1, '2025-04-08 13:07:43.492042'),
(98, 'pbkdf2_sha256$870000$17oPzdmf7pxFiMF8FdnAmZ$hZVslwTmFWKEO5FPT+ugUk228XHzxTKVDpyKMbXcHcA=', NULL, 0, 'sdhgsydytsfg@gmail.com', 'sdhhs', 'sdd', 'sdhgsydytsfg@gmail.com', 0, 1, '2025-04-09 03:25:31.031448'),
(99, 'pbkdf2_sha256$870000$MepPkComTn6KNobOOLl79H$7gGJ7mOGvKpS+QE4K2DZgLW2yAMG/7tpzbMhPC/vbII=', NULL, 0, 'nnnnnnnn@gmail.com', 'sjgduh', 'ushduhs', 'nnnnnnnn@gmail.com', 0, 1, '2025-04-09 03:55:32.538003'),
(100, 'pbkdf2_sha256$870000$ZEtPIsuq9JHrJlLBJPIk0V$kvUHoAzA1x8iyS5cKuFV8+Oei/AgxOEvWgEyhdCQOqQ=', NULL, 0, 'hsdshgds@gmail.com', 'djhf', 'sjdhus', 'hsdshgds@gmail.com', 0, 1, '2025-04-09 14:24:22.088117'),
(101, 'pbkdf2_sha256$870000$8iigyfKc5qFz38i3xnBhTY$kUxW91AEtZcOEhOrwAbDdYe7jgTc8RkQumWzvW93Ur8=', NULL, 0, 'shdgsgd@gmail.com', 'hghhh', 'hsgag', 'shdgsgd@gmail.com', 0, 1, '2025-04-09 15:32:42.150896'),
(102, 'pbkdf2_sha256$870000$4tCMbGZEX5P20O0kJx1CXj$IyCsNjpubv+o5VwcZewEQ76E7EtwxkwjLTgsk8xNR6g=', NULL, 0, 'smdshdjh@gmail.com', 'sjhdhhd', 'shdjhd', 'smdshdjh@gmail.com', 0, 1, '2025-04-09 15:56:13.930486'),
(103, 'pbkdf2_sha256$870000$jY5gVM7HtK1hBtBh1tq3KM$vYd8UWidVWyYeG47ASoJ6JPAa7x0UVjFeu1Zq15rQGw=', NULL, 0, 'nmnm@gmail.com', 'nnnnnnnnnnnnnn', 'nnnnnnnnn', 'nmnm@gmail.com', 0, 1, '2025-04-09 16:14:01.910779'),
(104, 'pbkdf2_sha256$870000$NuB67xgaDQVgL8KRWqXHc3$MEWrbjnNGZnFbgb14DDC304s2LGG3hRKDDiQujh6vaA=', NULL, 0, 'ff@gmail.com', 'ff', 'gg', 'ff@gmail.com', 0, 1, '2025-04-10 17:32:57.702762'),
(105, 'pbkdf2_sha256$870000$3P4aT7BzxlvWoMbgxVT2DG$mncZZ73nTF5+xtH7KjulMIcoCQrrTve58Hfjepmklto=', NULL, 0, 'hg@gmail.com', 'gg', 'gg', 'hg@gmail.com', 0, 1, '2025-04-10 17:48:53.629902'),
(106, 'pbkdf2_sha256$870000$ymngymKBRT78DIDHP9hho1$YYN88CkoCpnhhuiOYwhgeWRNXSKH24Pd2i7MUOv88ug=', NULL, 0, 'sgdhghg@gmail.com', 'rj', 'sgd', 'sgdhghg@gmail.com', 0, 1, '2025-04-10 19:07:16.868255'),
(107, 'pbkdf2_sha256$870000$6t4cx100lRYAVUdArVMsSt$Zjfvu3tLimn6amOjeaKKiMLHlY8FMTilwS7rcamnP+Q=', NULL, 0, 'jshdhdjh@gmail.com', 'shhdgd', 'sjgdsd', 'jshdhdjh@gmail.com', 0, 1, '2025-04-12 06:52:25.018069'),
(108, 'pbkdf2_sha256$870000$dazcyKvaBQQFAtj3vBqiA9$5e8acSR0A2azUSHkioQu0uqOhtBWzc8zp2bWhCK7TzY=', NULL, 0, 'hdghghgdh@gmail.com', 'djfhjhdjs', 'sjhd', 'hdghghgdh@gmail.com', 0, 1, '2025-04-12 07:18:39.202138'),
(109, 'pbkdf2_sha256$870000$77ZlAXxnLafXIJb9R1DZzR$1KtJjHrlWFRP2POCyrCMiVOaSbPiE3gJWzIP2lxIvU8=', NULL, 0, 'jshdjhsdjh@gmail.com', 'shgdhgsdh', 'fdjfhjhf', 'jshdjhsdjh@gmail.com', 0, 1, '2025-04-12 07:27:16.037287'),
(110, 'pbkdf2_sha256$870000$0ZyKpLkdJNHxQMwdTlc5jS$iDtrG4VobllXE801QGIzpRYcfNw12qdULMAFAg39HUM=', NULL, 0, 'jhshdhs@gmail.com', 'dnjbd', 'sjhdjhs', 'jhshdhs@gmail.com', 0, 1, '2025-04-12 16:11:52.986530'),
(111, 'pbkdf2_sha256$870000$aub7uKwZgPtgChobNWCxDf$znANNSBslSLZvONFcX5noels2rdezf48X+GkrjlOdh8=', NULL, 0, 'jsdhshgdh@gmail.com', 'sjdsjhd', 'sdhshdj', 'jsdhshgdh@gmail.com', 0, 1, '2025-04-12 17:15:03.125185'),
(112, 'pbkdf2_sha256$870000$mfB8XnF8CqaY9oalg7zgqq$534P4QyzZ7E5goEQKZCZwtX5DGxpSTSD2WnjSiTx/lQ=', NULL, 0, 'sdjsdj@gmail.com', 'jshdj', 'sjdhj', 'sdjsdj@gmail.com', 0, 1, '2025-04-12 17:58:34.598015'),
(113, 'pbkdf2_sha256$870000$w3kqgzz2SW2dGi1jiM4C3G$9irs40zh1uAUNmD8VDN1HXbumIQcAUMD/tDgu3U2JYU=', NULL, 0, 'shdjhsdhh@gmail.com', 'shdjhsjdh', 'jshdjhjshd', 'shdjhsdhh@gmail.com', 0, 1, '2025-04-14 19:04:42.729169'),
(114, 'pbkdf2_sha256$870000$nWiHQdbYenL3wxMmb9NHM4$jHxTQNW+Pzm4E+3hpjRnkBX1ZCIWR4PSJfKiBwfYP2w=', NULL, 0, 'alfahad@gmail.com', 'Alfahad', 'Tahil', 'alfahad@gmail.com', 0, 1, '2025-04-16 05:00:17.351500'),
(115, 'pbkdf2_sha256$870000$yISIMKyqEu9EMFJvwg8P76$tDZ+rhGPlIXKjl/P7VWpSmqM868uieS5GeypFyPbD18=', NULL, 0, 'name@gmail.com', 'sample', 'name', 'name@gmail.com', 0, 1, '2025-04-16 13:58:31.483923'),
(116, 'pbkdf2_sha256$870000$HowWgbnzTANr7cvxk4icUe$Hxm60Jcm9sDXihnwRsuGWhq2DdeN833FOeuXPOkKWSA=', NULL, 0, 'labang3@gmail.com', 'Dhaif', 'Labang', 'labang3@gmail.com', 0, 1, '2025-04-16 14:51:46.633449'),
(117, 'pbkdf2_sha256$870000$tPRYUOeehHuMdMi3pXO5fD$FlpauwVORnoyM9AmdCiGyFOaJhHqzEVOeDowcy8z2qE=', NULL, 0, 'hsgdhgshdg@gmail.com', 'rj', 'sbdhgsd', 'hsgdhgshdg@gmail.com', 0, 1, '2025-04-18 08:48:51.114612'),
(118, 'pbkdf2_sha256$870000$lez2OLLgXQ9qwlJezHzIGo$LNTA49jIPrs98UZZs8oCqnV47JzlAgOlVTNHvt0POFs=', NULL, 0, 'jshdshdsg@gmail.com', 'sjddu', 'hsgd', 'jshdshdsg@gmail.com', 0, 1, '2025-04-18 09:11:53.750543'),
(119, 'pbkdf2_sha256$870000$vr5lZlEMaXQkZ7NShnZVhC$YrU7Z5QULdupZD407M9MYetmgVJrfCOtw3oT/g+nUug=', NULL, 0, 'hsdghgshdgg@gmail.com', 'shdjhjsdjhs', 'jshdjhs', 'hsdghgshdgg@gmail.com', 0, 1, '2025-04-18 09:16:54.705643'),
(120, 'pbkdf2_sha256$870000$KBcSujMAowVitINbNskkrx$Pmt9Vz2lqxWM/Pg18cQRZ9qtXc0G2VMnzDCsMLS6bnc=', NULL, 0, 'hdhgdh@gmail.com', 'jshdjhsh', 'bshdhhsd', 'hdhgdh@gmail.com', 0, 1, '2025-04-18 09:29:48.421916'),
(121, 'pbkdf2_sha256$870000$sHorVbDoGxyjifbiWLD4wm$fQXdzo08EQC5dcXkGebj41pnRFxOCZ5d7nygArWDnok=', NULL, 0, 'jsdhshd@gmail.com', 'jshdjhsd', 'jshdjhsd', 'jsdhshd@gmail.com', 0, 1, '2025-04-18 10:23:34.272680'),
(122, 'pbkdf2_sha256$870000$ZoWBqi6gFQ9UC16Gx8KPzP$9bokFQw5q9XIF+tED6dvDRqVjUYu1hAYhSbikrf3jJU=', NULL, 0, 'shdhsduh@gmail.com', 'jsbdhsdh', 'jshhsdj', 'shdhsduh@gmail.com', 0, 1, '2025-04-18 10:38:25.289056'),
(123, 'pbkdf2_sha256$870000$0XNOfGrEkjfOZtHFqBryJG$lBnHop3huCqsnqCwtTv76ilILMXvr2TXCufedC6YWIY=', NULL, 0, 'sdgus@gmail.com', 'sjhdj', 'sgdhs', 'sdgus@gmail.com', 0, 1, '2025-04-18 10:46:51.298637'),
(124, 'pbkdf2_sha256$870000$WHWqXL1G8GuNDcJEa683b8$MqAFO6rKWprA2Q0tRfmozTGuMVDS/KSnm6rHbVallys=', NULL, 0, 'sudsuds@gmail.com', 'jsjydj', 'suds', 'sudsuds@gmail.com', 0, 1, '2025-04-18 11:00:00.115060'),
(125, 'pbkdf2_sha256$870000$kwQCNIu7CeMeSeaSp8156E$HbicZqPj3hVtexDfuQkMzFOL3phcHQizFVbshqiS9ro=', NULL, 0, 'jshjdhsh@gmail.como', 'jehejdhj', 'shghs', 'jshjdhsh@gmail.como', 0, 1, '2025-04-19 02:39:10.422812'),
(126, 'pbkdf2_sha256$870000$aR9euRqjezo2RyGCAfuE7r$3nJJmxH5bROASLmaXdXmVIAmKUADUlwyl/E1kYvKImo=', NULL, 0, 'shuhsydh@gmail.com', 'jshdjh', 'dushdjh', 'shuhsydh@gmail.com', 0, 1, '2025-04-19 02:58:11.094491'),
(127, 'pbkdf2_sha256$870000$bsgYUZX5phg78dGPyuL5km$fbQvNSWiYJtFlqv2yV4eyE3uKLdmzC4wVopWaHfxQTU=', NULL, 0, 'sdhsdjh@gmail.com', 'hshdhs', 'sdjhs', 'sdhsdjh@gmail.com', 0, 1, '2025-04-19 03:09:59.402875'),
(128, 'pbkdf2_sha256$870000$BcgfosHyDOoMS69fpy7mjm$F8YKO1bFNDZGaKqmKfGqdc9VKocFMK7ApiiCscrLxxs=', NULL, 0, 'gashghasg@gmail.com', 'ajshjhs', 'agshgah', 'gashghasg@gmail.com', 0, 1, '2025-04-19 03:24:28.307473'),
(129, 'pbkdf2_sha256$870000$ZCQCRJweErG49TkRa0Kirb$DwGUPDV9yPsGPDbg00Q4s3ItH14z9J+77Bv1uJ5BBsI=', NULL, 0, 'shdghsgdg@gmail.com', 'shdhjh', 'hshjhs', 'shdghsgdg@gmail.com', 0, 1, '2025-04-19 06:56:06.026937'),
(130, 'pbkdf2_sha256$870000$R1efq05wDUWlszJ0rZjqK2$rpTYARQ8G8tx65642j8u1izZOnTA87RE10tdoKzJ8uE=', NULL, 0, 'shdjhhd@gmail.com', 'dkfidds', 'ksjdkj', 'shdjhhd@gmail.com', 0, 1, '2025-04-20 06:45:27.175760'),
(131, 'pbkdf2_sha256$870000$FqtdVPt1aEHRumT4rkRmG4$VwMbvt/s+v6rsYPf3R4y7JkZxtpHP8wo3H7u8zWUnR4=', NULL, 0, 'lakuping3@gmail.com', 'kalvin', 'lakuping', 'lakuping3@gmail.com', 0, 1, '2025-04-20 09:54:33.270358'),
(132, 'pbkdf2_sha256$870000$BGJ5KS6W0E7FDPqcunL4Qg$DtW37Vb6rJ0UOLj8C1PxEmj6yvz+36tjCbzzKX4gSMk=', NULL, 0, 'mones@gmail.com', 'Julma', 'Mones', 'mones@gmail.com', 0, 1, '2025-04-20 11:23:31.306616'),
(133, 'pbkdf2_sha256$870000$aOmHFDFN8BdGOlTYzU9RBR$wgR3EjD9dtvuK6jUz6tw4D6fVuF1KYjbTlknkygYauk=', NULL, 0, 'smdhjhsd@gmail.com', 'sgdgd', 'jshdh', 'smdhjhsd@gmail.com', 0, 1, '2025-04-27 13:47:55.354274'),
(134, 'pbkdf2_sha256$870000$6bQhjfQ27VdBvW3suvRxuX$slDB9xVysEClaOUiHMmFh7FgYRCMcsAtRYK98RUZDv4=', NULL, 0, 'jshdjhs@gmail.com', 'jshdjhs', 'hsdhs', 'jshdjhs@gmail.com', 0, 1, '2025-04-27 13:51:29.405501'),
(135, 'pbkdf2_sha256$870000$hTy4KCPRjOnnCfTiVPIiQz$0cy083eCYhFnp6nvst9Ncixf+By2yA5w1HB0AHPkMwo=', NULL, 0, 'jshdjhs@gs.com', 'sjhdjsh', 'jshd', 'jshdjhs@gs.com', 0, 1, '2025-04-27 13:59:53.327812'),
(136, 'pbkdf2_sha256$870000$5qErBwf6apsGAo2XHBqtBe$L53oOPoA+2BIvHSJMGzYk527GM0qiiOHiOEWvIrX80E=', NULL, 0, 'shdjhsj@gmail.com', 'ksjdksj', 'mshdjhs', 'shdjhsj@gmail.com', 0, 1, '2025-04-27 14:52:42.052065'),
(137, 'pbkdf2_sha256$870000$36AJrZGvl91y5vzVqvlxjb$04MLhpmuoyjsnLh+z3q4tB9fNZCTMYW8qZCjLzsTRNU=', NULL, 0, 'mshdjhsjd@gmail.com', 'jshdjwdh', 'sjhdsh', 'mshdjhsjd@gmail.com', 0, 1, '2025-04-29 06:37:00.214831'),
(138, 'pbkdf2_sha256$870000$vYwXPetGc86xExiCJBJAKf$JyMUY6IQII78hnsB76/q4KWBswmJPmRjnprI96/A694=', NULL, 0, 'jsgdhgs@gmail.com', 'sgdgh', 'jgdshg', 'jsgdhgs@gmail.com', 0, 1, '2025-04-29 06:42:21.810840'),
(139, 'pbkdf2_sha256$870000$eNYIz0Uro9MPym9MZ0V79t$W7rEUuvBHq2RMhMi/rwT114BRp+KJrtZdJGykGF0lYY=', NULL, 0, 'sdghsgdhg@gmail.com', 'jshdjhsdj', 'djghgdh', 'sdghsgdhg@gmail.com', 0, 1, '2025-04-29 06:44:01.180276'),
(140, 'pbkdf2_sha256$870000$3m6hh311spyYWYmIhMlIMd$3h377MQGV12nPwPsPt6YrJTmftoLjIbuBfBIljbJ5XI=', NULL, 0, 'jsjdghsgdh@gmail.com', 'jsdhsjdh', 'sndshdj', 'jsjdghsgdh@gmail.com', 0, 1, '2025-04-29 06:47:58.182460'),
(141, 'pbkdf2_sha256$870000$RuCeZMoinVXyW6kuJ8iEsU$s2lJrrybypLWZmObblLlZR9M2PPc/t10rcJJTldkKkQ=', NULL, 0, 'shdghsgdh@gmail.com', 'sjdjhjh', 'shdhjhsd', 'shdghsgdh@gmail.com', 0, 1, '2025-04-29 06:51:36.761788'),
(142, 'pbkdf2_sha256$870000$Y830fqEdKityrnO6I1rkPl$vnOFAHpRLw+lcjLGage9RDAIA6Za/IS4584neLxEwqM=', NULL, 0, 'sdghgs@gmail.com', 'sjdhjsd', 'jshdjhsd', 'sdghgs@gmail.com', 0, 1, '2025-04-29 07:10:37.847104'),
(143, 'pbkdf2_sha256$870000$QplZX33Lz3C6d8TNCG4AZe$Wu1hHYNTonFysOuMBE95SNIKJi7f63XwDHxjka8ARjc=', NULL, 0, 'sdjhjshd@gmail.com', 'sdhjsd', 'djsdsj', 'sdjhjshd@gmail.com', 0, 1, '2025-04-29 09:14:47.194431'),
(144, 'pbkdf2_sha256$870000$g7cpn6kOvS0klAUBiZOKFr$rCeuPcctg0+CFR58027tcDJwy5wfkj3qbPdK/9a9jro=', NULL, 0, 'sdhjsd@gmail.com', 'jshdjhd', 'ksdjs', 'sdhjsd@gmail.com', 0, 1, '2025-04-29 14:38:07.211810'),
(145, 'pbkdf2_sha256$870000$nH2Rq2ZOxIWPpnaiG6dA3s$aT1mtmt+AcP/nt2EewKvNllb+PlIOOfrKOCeay52sLQ=', NULL, 0, 'jshdjhsd@gmail.com', 'shdjhd', 'sjdhjshd', 'jshdjhsd@gmail.com', 0, 1, '2025-04-29 14:59:36.208306'),
(146, 'pbkdf2_sha256$870000$No6Hi9tJ00jOE491olFB8Q$fFV4Ux2KCHKaUDpF8mFvXAGnBgyOo3LrUafnsUlTvKk=', NULL, 0, 'jdhfhdfh@gmail.com', 'sjhdjs', 'jshdjhsd', 'jdhfhdfh@gmail.com', 0, 1, '2025-04-29 15:07:34.565853'),
(147, 'pbkdf2_sha256$870000$f0Tnr9u5SwuNxo3L8mby2s$aF37KTUwwcPPeJgEafGwiUcnj82+lnprbl+dls1dHFo=', NULL, 0, 'jsdhjshd@gmail.com', 'smdjjdks', 'sdksjd', 'jsdhjshd@gmail.com', 0, 1, '2025-04-29 15:27:45.493257'),
(148, 'pbkdf2_sha256$870000$yxbNblOUy5cAx04q8zTfic$IU2g3d6HN3fDGVSLcGUUSgv1gVpbUYnLsncI4S3N2Kg=', NULL, 0, 'jsdjhjsd@gmail.com', 'sjdsjdsdjh', 'jshdhsdjh', 'jsdjhjsd@gmail.com', 0, 1, '2025-04-29 15:48:45.487506'),
(149, 'pbkdf2_sha256$870000$HtXTTohjKct0h8U14nrll6$bSVO//xOTDbYoMF7AVa7iP+fIdR8TTooPMd6+orSRsQ=', NULL, 0, 'jshdhs@gmail.com', 'sjhdjd', 'jhsdjhs', 'jshdhs@gmail.com', 0, 1, '2025-04-29 16:28:00.783654'),
(150, 'pbkdf2_sha256$870000$THOnJLCAkyCQjSdOvJ94mv$NlCEUqg9mFPSc5k3e9qOeUj2cFTPcXL6RA8iaSEdvNc=', NULL, 0, 'sjdhjshd@gmail.com', 'sjdjsdj', 'shdjhd', 'sjdhjshd@gmail.com', 0, 1, '2025-04-29 16:30:49.398389'),
(151, 'pbkdf2_sha256$870000$VxEPuwAsTWoiCuebMFqDDb$b2/nbdk7EoWRSIVOBz2MOiWdZ4qX//+g/lcmceG9KbI=', NULL, 0, 'hsdhshd@gmail.com', 'jsdhjd', 'jsdhsd', 'hsdhshd@gmail.com', 0, 1, '2025-04-29 16:34:44.520733'),
(153, 'pbkdf2_sha256$870000$DNBBDFhsOloILX1VOaZSeC$hq6YuFeINSiIcWHiqgFuy+0/HQXNESo+B/UOQskCXaA=', NULL, 0, 'jshdjhsdsdh@gmail.com', 'shdjhjsd', 'jshdjhds', 'jshdjhsdsdh@gmail.com', 0, 1, '2025-04-29 17:08:21.812541'),
(154, 'pbkdf2_sha256$870000$Ew7SYtNYFJhYwuR5tZpr7J$/TEJVYsAqPw+xD7m9oS+/UsELJ77FrITDulN6Yj6SMQ=', NULL, 0, 'sdhjhsdhh@gmail.com', 'sdsdhjhjs', 'dsjdhj', 'sdhjhsdhh@gmail.com', 0, 1, '2025-04-29 17:49:22.534173'),
(155, 'pbkdf2_sha256$870000$fYQZ1oss86N4i5gWplvEF1$JUnROdSexEEq4VwCHBjGuC15phkUQ9qtUS/DJ+wWCvI=', NULL, 0, 'jsdshd@gmail.com', 'msdjhsd', 'jshjd', 'jsdshd@gmail.com', 0, 1, '2025-04-29 18:15:34.860036'),
(156, 'pbkdf2_sha256$870000$m5DI3pF4J9prcEN3bMPaPL$xsKuBudlK8Ul2TfNATmZITZEaALu1vkNjfkbSJfsAE8=', NULL, 0, 'jhsahs@gmail.com', 'sdhjsd', 'jajsja', 'jhsahs@gmail.com', 0, 1, '2025-04-29 18:27:07.466144'),
(157, 'pbkdf2_sha256$870000$Lhm4VfXYc2NJHqHgUpvcNU$1u6TrOPXyPGFI3W6S9bCjJ3QtXMadUqg+M8xLuRDsGE=', NULL, 0, 'asjasj@gmail.com', 'jhsh', 'nshja', 'asjasj@gmail.com', 0, 1, '2025-04-29 18:59:08.580923'),
(158, 'pbkdf2_sha256$870000$WmNdXnJbX6o9R86LOWp9Mh$hAEEXl/FhS6GuW4ndrhLUQ7/FV5zM7XhtRbrDQaDEjw=', NULL, 0, 'sdhjshdj@gmail.com', 'jdhjshd', 'kdsjjd', 'sdhjshdj@gmail.com', 0, 1, '2025-04-29 19:38:32.338736'),
(159, 'pbkdf2_sha256$870000$fF0qiDqHH1KMp9ZDBkaLxZ$w6UOWPhqwng6Z6m6YU1XLuSnPi/Z5ORWayB8v8MP2JU=', NULL, 0, 'jshdjhsdj@gmail.com', 'sdhjhsd', 'sdhs', 'jshdjhsdj@gmail.com', 0, 1, '2025-04-29 20:07:55.300485'),
(160, 'pbkdf2_sha256$870000$L7jzDMMgnrAYENblhfyQN8$q+jgOnuAklxJ/HTQ3uxg39IYtD7kfEz6c81yU6pHhus=', NULL, 0, 'alfahad3@gmail.com', 'Alfahad', 'Tahil', 'alfahad3@gmail.com', 0, 1, '2025-04-29 22:56:28.194565'),
(161, 'pbkdf2_sha256$870000$Hb255Ona4raNUwSypclFy3$3szm/XAAmtsAsM+Ooi40MO2U8CPoDB5puCIPPMExk9A=', NULL, 0, 'francis123@gmail.com', 'francis', 'francisco', 'francis123@gmail.com', 0, 1, '2025-04-30 06:05:51.824817'),
(162, 'pbkdf2_sha256$870000$c0keLLHOPY1yVtfsyFDDzh$VtCw3snvljvqijCS91INM8PcZi9jrvup2/1R2gzCt2M=', NULL, 0, 'credo@gmail.com', 'Alfahad ', 'Credo', 'credo@gmail.com', 0, 1, '2025-05-07 06:47:29.745133'),
(163, 'pbkdf2_sha256$870000$nn47fpEjQ4iZrRWsXis88v$fA17/BlVnLnajdg1cccMDmjB8GtCeSpg35vmC9MAAzY=', NULL, 0, 'jshdjhsjh@gmail.com', 'sjdsyd', 'kskdjskd', 'jshdjhsjh@gmail.com', 0, 1, '2025-05-15 06:26:24.287754'),
(164, 'pbkdf2_sha256$870000$9EewOc3w5dmvXOhnlskbtG$9OVDJkO3I8cjo37KA+CEMzv0DK0D2WTW5IuQiWbSJDE=', NULL, 0, 'sjdhsdjh@gmail.com', 'djfhjhdf', 'sjdhjhsjd', 'sjdhsdjh@gmail.com', 0, 1, '2025-05-15 07:08:07.140284'),
(165, 'pbkdf2_sha256$870000$xtIlpsZGgMcJhNn6lws4ME$ZuURlPQn5CqB6o2rdFyV5JBdGXH0pk9FFY76chEGlmc=', NULL, 0, 'jsjhdjhsdjh@gmail.com', 'dhfjhdjfhdh', 'sjhdjhdhd', 'jsjhdjhsdjh@gmail.com', 0, 1, '2025-05-15 07:18:41.596058'),
(166, 'pbkdf2_sha256$870000$nv9I6CNG5s1ViEBdqt00s6$fK2rQzXfHk2OdGwJPO3O9dAdadKd8Pv2kti03Xeb66c=', NULL, 0, 'sjgdhgshdghg@gmail.com', 'sjhdjshjdhs', 'jsdsjhdshj@gmail.com', 'sjgdhgshdghg@gmail.com', 0, 1, '2025-05-15 14:57:40.336028'),
(167, 'pbkdf2_sha256$870000$WpUpUvVJDWb5GoMevYIPVS$Be6oeOTYsRqYBTNPs6AhXensvWrMLLM31t+swzKpcp0=', NULL, 0, 'ysdystyy@gmail.com', 'sdghhshduh', 'hsgdhgshd', 'ysdystyy@gmail.com', 0, 1, '2025-05-15 15:16:38.977047'),
(168, 'pbkdf2_sha256$870000$xF3kO58gLQ2HMsGHWKij1E$KJ8QCys/nOtSoyst8CBFI7qKit3WXWOF9VrHDKDzIIw=', NULL, 0, 'jshdhsjd@gmail.com', 'sjdhhsd', 'sjhdjhsjd', 'jshdhsjd@gmail.com', 0, 1, '2025-05-15 15:55:14.979499'),
(169, 'pbkdf2_sha256$870000$GQP02qehfvuIQCq759rRD3$d0fM62R0vQEwzDWKMuaejc1t2kK46HUfPkpK0/uU+9A=', NULL, 0, 'dsgsfdgfsg@gmail.com', 'sjdhhsd', 'sjhdjhsjd', 'dsgsfdgfsg@gmail.com', 0, 1, '2025-05-15 15:56:05.500574'),
(170, 'pbkdf2_sha256$870000$QVhQc5tvzbxsL0w2nDZm8o$HWUlBx4Agfy5sG3Aom9CAcOUJCmp/bXLLAAbC+7ULfQ=', NULL, 0, 'kalvinlakupingggg@gmail.com', 'Lakuping', 'kalvin', 'kalvinlakupingggg@gmail.com', 0, 1, '2025-05-15 18:39:06.854757'),
(175, 'pbkdf2_sha256$870000$yZoFL8Ww8qVesmquqiBxZ7$RbmHI5EMKjOBrQuK746Yhb2RI+m51a6rM6d+8HHOCi4=', NULL, 0, 'mieee3381@gmail.com', 'Lakuping', 'kalvin', 'mieee3381@gmail.com', 0, 1, '2025-05-16 02:13:07.355678'),
(176, 'pbkdf2_sha256$870000$sYyNz5ks6m1R2oVbztnU8a$7VOeD/gBkeqmsTGDmc7V+odlFW/lWiNzel0PKanRrYY=', NULL, 0, 'jon.jhetuna@gmail.com', 'Lakuping', 'kalvin', 'jon.jhetuna@gmail.com', 0, 1, '2025-05-16 07:49:27.443930'),
(177, 'pbkdf2_sha256$600000$Muf0Iso1eo1i3uBD3bREsT$QINVIB+XRnjOpFFBxt8NAVZBcfuXHUiPTBN3RMsZQ7I=', NULL, 1, 'faminianochristianjude@gmail.com', 'Christian', 'Faminiano', 'faminianochristianjude@gmail.com', 1, 1, '2025-06-19 11:02:12.324625'),
(178, 'pbkdf2_sha256$600000$Xi52Cn0vMUJl5SahhdJncf$Gh1qVvXkUrM36+Gz7gtEuqwDgB8VytTN47qS4GaUkwE=', NULL, 0, 'meow1@gmail.com', 'Micheal', 'Jordan', 'meow1@gmail.com', 0, 1, '2025-06-19 17:07:30.551855'),
(179, 'pbkdf2_sha256$600000$4KNfaXKDupvOHZou6iPUnC$kTRMunjJjKuUtTxucm96v614DubvLg0yUiDoQfcAx8g=', NULL, 0, 'meow3@gmail.com', 'Michael', 'Jordan', 'meow3@gmail.com', 0, 1, '2025-06-24 17:58:37.475662'),
(180, 'pbkdf2_sha256$600000$wxWYUZaxzG9DJoAjregldb$Zc0yvgMI9PLQyHRfd1D3XnpjCRrkIQZh8+A1rg4pPFM=', NULL, 0, 'meow5@gmail.com', 'Rown', 'Faminiano', 'meow5@gmail.com', 0, 1, '2025-06-24 21:18:59.948641'),
(181, 'pbkdf2_sha256$600000$jGuAOPPR4PoFptxYxAifd4$zsEsViZc7Q6y15FdHO5MkOX4o69xILf+3mgiB8m+9W4=', NULL, 0, 'meow6@gmail.com', 'Nke', 'Faminiano', 'meow6@gmail.com', 0, 1, '2025-06-25 01:27:22.784430');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `base_announcement`
--

CREATE TABLE `base_announcement` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `type` varchar(20) NOT NULL,
  `date` date NOT NULL,
  `icon` varchar(50) NOT NULL,
  `author` varchar(100) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_announcement`
--

INSERT INTO `base_announcement` (`id`, `title`, `content`, `type`, `date`, `icon`, `author`, `link`, `is_active`, `created_at`, `updated_at`, `created_by_id`) VALUES
(2, 'jmans', 'The most common type of arthritis, osteoarthritis involves wear-and-tear damage to a joint\'s cartilage — the hard, slick coating on the ends of bones where they form a joint. Cartilage cushions the ends of the bones and allows nearly frictionless joint motion, but enough damage can result in bone grinding directly on bone, which causes pain and restricted movement. This wear and tear can occur over many years, or it can be hastened by a joint injury or infection.\n\nOsteoarthritis also causes changes in the bones and deterioration of the connective tissues that attach muscle to bone and hold the joint together. If cartilage in a joint is severely damaged, the joint lining may become inflamed and swollen.\n\nRheumatoid arthritis\nIn rheumatoid arthritis, the body\'s immune system attacks the lining of the joint capsule, a tough membrane that encloses all the joint parts. This lining (synovial membrane) becomes inflamed and swollen. The disease process can eventually destroy cartilage and bone within the joint.\n\nRisk factors\nRisk factors for arthritis include:\n\nFamily history. Some types of arthritis run in families, so you may be more likely to develop arthritis if your parents or siblings have the disorder.\nAge. The risk of many types of arthritis — including osteoarthritis, rheumatoid arthritis and gout — increases with age.\nYour sex. Women are more likely than men to develop rheumatoid arthritis, while most of the people who have gout, another type of arthritis, are men.\nPrevious joint injury. People who have injured a joint, perhaps while playing a sport, are more likely to eventually develop arthritis in that joint.\nObesity. Carrying excess pounds puts stress on joints, particularly your knees, hips and spine. People with obesity have a higher risk of developing arthritis.', 'Update', '2025-04-19', 'fas fa-book-open', 'Admin Team', NULL, 1, '2025-04-19 08:24:33.199368', '2025-06-24 21:27:02.302106', 3),
(4, 'pasado kayo lahat', 'jashjahs', 'New', '2025-04-20', 'fas fa-bell', 'Admin Team', 'sjhdjhsjhd', 1, '2025-04-20 06:40:07.673622', '2025-06-24 21:27:02.314075', 3);

-- --------------------------------------------------------

--
-- Table structure for table `base_appointment`
--

CREATE TABLE `base_appointment` (
  `id` bigint(20) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(254) NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `school_name` varchar(255) DEFAULT NULL,
  `college_level` varchar(20) NOT NULL,
  `preferred_date` date NOT NULL,
  `time_slot` varchar(20) NOT NULL,
  `status` varchar(30) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `program_id` bigint(20) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `applicant_type` varchar(50) DEFAULT NULL,
  `birth_day` varchar(2) DEFAULT NULL,
  `birth_month` varchar(2) DEFAULT NULL,
  `birth_year` varchar(4) DEFAULT NULL,
  `citizenship` varchar(50) DEFAULT NULL,
  `college_course` varchar(100) DEFAULT NULL,
  `college_type` varchar(50) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `high_school_code` varchar(50) DEFAULT NULL,
  `home_address` longtext DEFAULT NULL,
  `is_first_time` tinyint(1) DEFAULT NULL,
  `school_address` longtext DEFAULT NULL,
  `school_graduation_date` varchar(50) DEFAULT NULL,
  `times_taken` int(11) DEFAULT NULL,
  `is_submitted` tinyint(1) NOT NULL,
  `test_center_id` bigint(20) DEFAULT NULL,
  `test_room_id` bigint(20) DEFAULT NULL,
  `test_session_id` bigint(20) DEFAULT NULL,
  `assigned_test_time_slot` varchar(20) DEFAULT NULL,
  `is_time_slot_modified` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_appointment`
--

INSERT INTO `base_appointment` (`id`, `full_name`, `email`, `contact_number`, `school_name`, `college_level`, `preferred_date`, `time_slot`, `status`, `created_at`, `updated_at`, `program_id`, `user_id`, `age`, `applicant_type`, `birth_day`, `birth_month`, `birth_year`, `citizenship`, `college_course`, `college_type`, `gender`, `high_school_code`, `home_address`, `is_first_time`, `school_address`, `school_graduation_date`, `times_taken`, `is_submitted`, `test_center_id`, `test_room_id`, `test_session_id`, `assigned_test_time_slot`, `is_time_slot_modified`) VALUES
(13, 'Kalvin lakuping', 'kalvinlakuping@gmail.com', '936628826', 'Taluksangay', '', '2025-03-10', 'afternoon', 'claimed', '2025-03-09 04:38:20.791677', '2025-03-22 17:11:46.084630', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(14, 'uywuyuqw', 'whshwh@gmail.com', '78363653', 'Taluksangay', '', '2025-03-09', 'afternoon', 'claimed', '2025-03-09 04:40:09.333945', '2025-03-22 17:12:53.556253', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(15, 'agsygs', 'ahegsygs@gmail.com', '933656356', 'raluy', '', '2025-03-10', 'morning', 'rejected', '2025-03-09 05:32:19.164976', '2025-03-09 05:36:37.724143', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(16, 'sjhswh', 'shgdgsgydg@gmail.com', '93874374', 'shgdhhdg', '', '2025-03-19', 'morning', 'rescheduled', '2025-03-09 06:04:52.031647', '2025-03-15 10:05:04.113859', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(17, 'eweyy', 'yteywte@gmail.com', '93947364', 'wyetywty', '', '2025-03-13', 'morning', 'approved', '2025-03-09 06:06:55.280684', '2025-04-12 16:37:56.266831', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(18, 'sgdhgsd', 'Taluksangay@gmail.com', '475864775', 'ahsggfsg', '', '2025-03-09', 'morning', 'rejected', '2025-03-09 06:11:27.114227', '2025-03-13 12:55:33.411106', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(19, 'gehgwh', 'gsfdgfsgdfg@gmail.com', '3848636467', 'shgsdhg', '', '2025-03-11', 'afternoon', 'rejected', '2025-03-09 06:16:23.584802', '2025-03-13 12:55:31.169265', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(20, 'shjhwj', 'shjhdhash@gmail.com', '586975', 'dnjhhd', '', '2025-03-02', 'afternoon', 'approved', '2025-03-09 06:18:22.615543', '2025-04-12 16:37:56.291136', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(21, 'sjashjhs', 'hagsgas@gmail.com', '903089408', 'ahsgasgg', '', '2025-03-10', 'afternoon', 'rejected', '2025-03-09 06:19:59.369814', '2025-03-13 12:55:31.741744', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(22, 'sjdhhsd', 'shj@gmail.com', '9353651', 'jassgdhg', '', '2025-04-12', 'morning', 'claimed', '2025-03-09 06:21:51.886506', '2025-03-13 17:02:07.158049', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(23, 'kakkaka', 'ajshhs@gmail.com', '6523562536', 'ahgsgasg@gmail.com', '', '2025-03-09', 'afternoon', 'rejected', '2025-03-09 06:25:12.632759', '2025-03-13 12:55:32.034541', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(24, 'sjdhshd', 'ahsgags@gmail.com', '8973347', 'sdytsdy', '', '2025-03-23', 'afternoon', 'claimed', '2025-03-09 06:28:29.517227', '2025-03-13 16:37:05.100541', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(25, 'weuywe', 'hdsdusdh@gmail.com', '398934', 'sjhdjhsjd', '', '2025-03-15', 'morning', 'claimed', '2025-03-09 07:09:01.341333', '2025-03-22 17:41:17.029741', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(26, 'jahss', 'sbdhghsd@gmail.com', '3866376', 'shsgdhd', '', '2025-03-10', 'morning', 'rejected', '2025-03-09 14:42:00.800155', '2025-03-13 12:55:31.287674', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(27, 'sdgsd', 'wdhgd@gmail.com', '2399898328', 'sdhgd', '', '2025-03-12', 'afternoon', 'rejected', '2025-03-09 17:49:04.073481', '2025-03-13 12:55:31.021678', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(28, 'nbdf', 'sgdhgsh@gmail.com', '99347834', 'ndhghdg', '', '2025-03-10', 'afternoon', 'rejected', '2025-03-09 18:23:54.256772', '2025-03-13 12:55:31.423594', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(29, 'Credo Odrec', 'shdgdhsgd@gmail.com', '309408345974', 'aghfsfgfgdfgfsfd', '', '2025-03-28', 'morning', 'claimed', '2025-03-10 06:47:23.164343', '2025-03-13 16:33:13.845109', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(30, 'ehhhwe', 'shusgdgsg@gmail.com', '8939289', 'jwehwhe', '', '2025-03-11', 'morning', 'approved', '2025-03-11 14:54:17.507535', '2025-04-12 16:37:56.277084', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(31, 'vinnn', 'skhdsjhd@gmail.com', '38949384', 'isihdusud', '', '2025-03-29', 'afternoon', 'claimed', '2025-03-11 15:09:58.779404', '2025-03-13 16:33:12.760955', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(32, 'sh', 'jsdhhdg@gmail.com', '384874', 'erhgerg', '', '2025-03-26', 'afternoon', 'claimed', '2025-03-11 17:51:32.666636', '2025-03-13 16:33:14.869880', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(33, 'sdhsgdy', 'durant@gmail.com', '37476734', 'sgdygshgd', '', '2025-03-12', 'morning', 'rejected', '2025-03-12 09:38:02.236446', '2025-03-13 12:55:29.300935', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(34, 'kevin', 'durant@gmail.com', '834786346', 'sjhdhhhd', '', '2025-03-13', 'afternoon', 'rejected', '2025-03-12 09:49:49.531307', '2025-03-13 12:55:29.150148', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(35, 'kabang', 'durant@gmail.com', '9863465', 'kabs', '', '2025-03-13', 'morning', 'rejected', '2025-03-12 10:00:51.761764', '2025-03-13 12:55:29.018885', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(36, 'kabs', 'durant@gmail.com', '99778', 'sdhsgdgd', '', '2025-03-13', 'morning', 'approved', '2025-03-12 10:02:11.010527', '2025-04-12 16:37:56.260648', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(37, 'sdhjhd', 'durant@gmail.com', '94785745', 'shdshd', '', '2025-03-30', 'afternoon', 'claimed', '2025-03-12 10:54:57.201554', '2025-03-13 16:33:09.245698', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(38, 'wjhj', 'durant@gmail.com', '99000', 'whejhw', '', '2025-03-13', 'morning', 'rejected', '2025-03-12 11:00:47.329831', '2025-03-13 12:55:28.912899', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(39, 'sdhhs', 'durant@gmail.com', '394787', 'avsfgsgg', '', '2025-03-20', 'morning', 'rejected', '2025-03-12 11:03:08.364928', '2025-03-13 12:55:35.134362', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(40, 'dghg', 'durant@gmail.com', '8397988', 'shgdhsghgd', '', '2025-03-13', 'afternoon', 'rejected', '2025-03-12 11:07:36.365832', '2025-03-13 12:55:28.765666', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(41, 'dshsh', 'vebe@gmail.com', '99879898', 'sgdhsghd', '', '2025-03-13', 'afternoon', 'rejected', '2025-03-12 13:40:51.337974', '2025-03-13 12:55:27.110905', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(42, 'dghhdg', 'demo@gmail.com', '39483748', 'jdhjdh', '', '2025-03-19', 'morning', 'claimed', '2025-03-12 13:43:40.783095', '2025-03-13 17:53:05.606055', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(43, 'step', 'step@gmail.com', '93643764', 'dhshsj', '', '2025-03-06', 'afternoon', 'rescheduled', '2025-03-12 13:47:25.743168', '2025-03-15 09:08:38.747347', 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(44, 'shdsd', 'dem@gmail.com', '394374887', 'skdjkjj', '', '2025-03-14', 'afternoon', 'rejected', '2025-03-12 13:59:14.616225', '2025-03-13 12:55:30.858278', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(45, 'dhjdh', 'demoo@gmail.com', '938947347', 'sdjd', '', '2025-03-15', 'afternoon', 'rescheduled', '2025-03-12 14:02:56.920313', '2025-03-18 13:03:58.424774', 15, 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(47, 'sdhgsgdg', 'boss@gmail.com', '8293723', 'shdjhshdhuh', '', '2025-03-21', 'afternoon', 'approved', '2025-03-12 14:14:38.357268', '2025-04-12 16:37:56.245776', 15, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(48, 'sjhdsh', 'vanlo@gmail.com', '297732339', 'sjdijsjd', '', '2025-03-31', 'morning', 'claimed', '2025-03-12 14:16:12.536646', '2025-03-13 16:00:05.951844', 15, 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(49, 'fran', 'fran@gmail.com', '46545', 'sjgdsjdh', '', '2025-03-20', 'morning', 'claimed', '2025-03-13 00:04:52.690715', '2025-03-13 17:22:46.031199', 15, 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(50, 'wgfgwg', 'fran@gmail.com', '9927487', '4983949', '', '2025-03-14', 'morning', 'claimed', '2025-03-13 00:17:55.117739', '2025-03-22 17:09:17.667932', 12, 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(51, 'step curry', 'step@gmail.com', '83473748', 'new york', '', '2025-03-14', 'afternoon', 'rescheduled', '2025-03-13 02:08:21.175312', '2025-04-02 06:46:14.744137', 12, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(52, 'steppp', 'step@gmail.com', '39748487', 'Talu', '', '2025-03-14', 'morning', 'rejected', '2025-03-13 02:47:01.325802', '2025-03-13 18:14:14.003149', 11, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(53, 'kalvin lakuping', 'manong@gmail.com', '94546548', 'taluksangay', '', '2025-03-19', 'afternoon', 'claimed', '2025-03-13 12:47:01.476119', '2025-03-13 16:03:59.540191', 11, 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(54, 'kalvin dos', 'demoo@gmail.com', '93637253562', 'Taluksangay', '', '2025-03-14', 'afternoon', 'rejected', '2025-03-13 17:11:13.525116', '2025-03-13 18:21:13.394926', 12, 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(55, 'nnnn', 'demoo@gmail.com', '20009090', 'tafdsasfsff', '', '2025-03-15', 'afternoon', 'claimed', '2025-03-13 20:19:01.851538', '2025-03-22 17:37:24.343635', 11, 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(57, 'Alken James', 'alken@gmail.com', '9487848736', 'Tetuan kids', '', '2025-03-23', 'afternoon', 'claimed', '2025-03-14 00:21:10.615043', '2025-03-14 00:29:06.648820', 11, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(58, 'Alken', 'alken@gmail.com', '4985948598', 'Tetuan', '', '2025-03-25', 'morning', 'claimed', '2025-03-14 00:30:40.588733', '2025-03-14 00:34:04.144743', 12, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(59, 'demooo', 'step@gmail.com', '90945892', '450', '', '2025-03-22', 'afternoon', 'approved', '2025-03-15 09:32:41.568803', '2025-04-12 16:37:56.215930', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(60, 'shjhj', 'step@gmail.com', '948384989', 'shdjhshd', '', '2025-03-28', 'morning', 'approved', '2025-03-15 09:41:27.011893', '2025-04-12 16:37:56.150546', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(61, 'asshjs', 'step@gmail.com', '278329', 'husdjhds', '', '2025-03-20', 'afternoon', 'approved', '2025-03-15 09:43:32.613312', '2025-04-12 16:37:56.254023', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(62, 'shgdhhsgd', 'step@gmail.com', '9459452', 'hsdjhhsj', '', '2025-03-08', 'afternoon', 'approved', '2025-03-15 09:47:58.041360', '2025-04-12 16:37:56.282042', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(63, 'ashuhau', 'step@gmail.com', '394039', 'sjhjhsh', '', '2025-03-15', 'afternoon', 'rescheduled', '2025-03-15 09:53:09.427870', '2025-03-15 09:58:03.135019', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(64, 'shdjshjdh', 'step@gmail.com', '348039409', 'hasjhs', '', '2025-03-14', 'afternoon', 'rescheduled', '2025-03-15 10:03:33.724711', '2025-03-15 10:05:16.265948', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(65, 'ba', 'step@gmail.com', '4950459', 'shshjhsh', '', '2025-03-22', 'morning', 'rescheduled', '2025-03-15 10:05:40.086923', '2025-03-15 10:18:12.468385', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(66, 'sgdhsgd', 'step@gmail.com', '82873828', 'snhd', '', '2025-03-13', 'afternoon', 'rescheduled', '2025-03-15 10:20:00.170826', '2025-03-15 10:23:36.983961', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(67, 'shdysud', 'step@gmail.com', '882743278', 'hajshjhas', '', '2025-03-26', 'afternoon', 'rescheduled', '2025-03-15 10:23:36.951081', '2025-03-15 10:27:30.147904', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(68, 'shejhj', 'step@gmail.com', '48594950', 'hdjshdjh', '', '2025-03-28', 'afternoon', 'rescheduled', '2025-03-15 10:27:30.131671', '2025-03-15 10:30:05.769373', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(69, 'kalla', 'step@gmail.com', '59049', 'shjdhshd', '', '2025-03-29', 'morning', 'rescheduled', '2025-03-15 10:30:05.752680', '2025-03-15 10:37:44.062387', 15, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(70, 'jjj', 'h@gmail.com', '454958', 'shgshgs', '', '2025-03-22', 'afternoon', 'rescheduled', '2025-03-15 10:40:56.605529', '2025-03-15 10:42:05.952575', 15, 32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(71, 'jjj', 'h@gmail.com', '454958', 'shgshgs', '', '2025-03-29', 'afternoon', 'rescheduled', '2025-03-15 10:42:05.911598', '2025-03-15 10:57:33.070314', 15, 32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(72, 'jjj', 'h@gmail.com', '454958', 'shgshgs', '', '2025-03-30', 'morning', 'claimed', '2025-03-15 10:57:33.016788', '2025-03-15 11:13:28.984684', 15, 32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(73, 'jj', 'h@gmail.com', '95837335', '0569595533', '', '2025-03-18', 'afternoon', 'claimed', '2025-03-15 11:22:54.444295', '2025-03-15 11:25:45.095208', 12, 32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(74, 'jjsdjj', 'h@gmail.com', '9497474', 'kfgkjfg', '', '2025-03-28', 'afternoon', 'claimed', '2025-03-15 14:05:46.357059', '2025-03-22 17:33:28.807752', 11, 32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(75, 'd', 'd@gmail.com', '293920', 'sjhsdh', '', '2025-03-22', 'afternoon', 'approved', '2025-03-15 14:33:24.257784', '2025-04-12 16:37:56.211047', 15, 33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(76, 'mdhj', 'a@gmail.com', '82239238', 'jdhfjhd', '', '2025-03-22', 'afternoon', 'approved', '2025-03-15 14:35:15.281526', '2025-04-12 16:37:56.206042', 15, 34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(77, 'dhjh', 'r@gmail.com', '394839', 'shdjdh', '', '2025-03-22', 'afternoon', 'rescheduled', '2025-03-15 14:36:44.745908', '2025-03-18 14:54:20.813657', 15, 35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(78, 'yyuyuy', 's@gmail.com', '908989798', 'jjhjhjhjh', '', '2025-03-22', 'morning', 'approved', '2025-03-15 14:49:27.494021', '2025-04-12 16:37:56.197135', 15, 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(79, 'cgc', 'w@gmail.com', '99899899', 'vbvbv', '', '2025-03-21', 'morning', 'approved', '2025-03-15 15:10:34.912255', '2025-04-12 16:37:56.240297', 15, 37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(80, 'sgdhgsdg', 'aa@gmail.com', '929309029', 'sgfdgfs', '', '2025-03-21', 'afternoon', 'approved', '2025-03-15 15:11:51.501511', '2025-04-12 16:37:56.231100', 15, 38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(81, 'jsdhhh', 'bb@gmail.com', '3873283', 'dhjsdh', '', '2025-03-21', 'morning', 'approved', '2025-03-15 15:13:56.686745', '2025-04-12 16:37:56.224741', 15, 39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(82, 'sdjsddk', 'g@gmail.com', '903433', 'bdbvbs', '', '2025-03-19', 'afternoon', 'rescheduled', '2025-03-15 15:16:26.084846', '2025-03-15 15:18:50.010851', 15, 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(83, 'sdjsddk', 'g@gmail.com', '903433', 'bdbvbs', '', '2025-03-27', 'morning', 'approved', '2025-03-15 15:18:49.982363', '2025-04-12 16:37:56.164336', 15, 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(84, 'jhjhh', 'g@gmail.com', '87384783748', 'jsdjshdhsd', '', '2025-03-26', 'morning', 'rescheduled', '2025-03-16 02:53:14.134481', '2025-03-16 02:55:51.563318', 12, 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(85, 'jhjhh', 'g@gmail.com', '87384783748', 'jsdjshdhsd', '', '2025-03-27', 'morning', 'approved', '2025-03-16 02:55:51.546582', '2025-04-12 16:37:56.158237', 12, 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(86, 'sgdhsh', 'ddd@gmail.com', '33334344', 'jasbjsj', '', '2025-03-25', 'afternoon', 'rescheduled', '2025-03-16 04:45:16.005152', '2025-03-16 04:48:37.397005', 15, 42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(87, 'sgdhsh', 'ddd@gmail.com', '33334344', 'jasbjsj', '', '2025-03-31', 'morning', 'claimed', '2025-03-16 04:48:37.334075', '2025-03-22 17:00:05.383332', 15, 42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(88, 'ghag', 'abc@gmail.com', '6354653', 'sgfdf', '', '2025-03-20', 'morning', 'rescheduled', '2025-03-16 08:57:14.212638', '2025-03-16 09:58:31.282000', 15, 45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(89, 'ghag', 'abc@gmail.com', '6354653', 'sgfdf', '', '2025-03-28', 'morning', 'claimed', '2025-03-16 09:58:31.213521', '2025-03-27 14:57:28.824489', 15, 45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(93, 'xnjshd', 'dde@gmail.com', '754847878', 'dhfhdfh', '', '2025-03-21', 'morning', 'rescheduled', '2025-03-16 13:22:09.525372', '2025-03-16 13:23:40.714751', 15, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(94, 'xnjshd', 'dde@gmail.com', '754847878', 'dhfhdfh', '', '2025-03-28', 'morning', 'claimed', '2025-03-16 13:23:40.693048', '2025-03-22 17:44:52.683096', 15, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(97, 'sample', 'account@gmail.com', '9485984854', 'sample', '', '2025-03-27', 'afternoon', 'rescheduled', '2025-03-19 05:42:08.739386', '2025-03-19 05:46:23.450003', 11, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(98, 'sample', 'account@gmail.com', '9485984854', 'sample', '', '2025-03-29', 'afternoon', 'claimed', '2025-03-19 05:46:23.387475', '2025-03-22 17:07:46.442021', 11, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(99, 'sjydu', 'dddd@gmail.com', '5605069059', 'sgdysydygsydgysgdysgydgsygdysgdygsgdysgdygsydsgdgs', '', '2025-03-25', 'morning', 'approved', '2025-03-21 13:06:41.382916', '2025-04-12 16:37:56.190926', 15, 60, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(100, 'kalvin', 'dddd@gmail.com', '5865069009', 'Western Mindanao State University', '', '2025-03-29', 'morning', 'claimed', '2025-03-21 13:12:48.771059', '2025-03-22 17:03:11.136189', 11, 60, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(101, 'sdhshd', 'dddd@gmail.com', '904903940', 'jdhjhsdjh', '', '2025-03-27', 'afternoon', 'claimed', '2025-03-21 14:36:47.630037', '2025-03-26 01:36:25.651643', 12, 60, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(102, 'xdhu', 'sdghsd@gmail.com', '596095609', 'xmnjhxdjhsd', '', '2025-03-28', 'morning', 'rescheduled', '2025-03-21 14:48:24.609837', '2025-03-21 14:51:33.577568', 11, 61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(103, 'xdhu', 'sdghsd@gmail.com', '596095609', 'xmnjhxdjhsd', '', '2025-03-29', 'morning', 'claimed', '2025-03-21 14:51:33.550475', '2025-03-22 17:02:24.490355', 11, 61, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(104, 'sjgdhg', 'gsgg@gmail.com', '940904930', 'shudhshd', '', '2025-03-26', 'morning', 'claimed', '2025-03-24 03:49:25.059087', '2025-03-27 14:57:18.267737', 15, 66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(105, 'dsd', 'gsgg@gmail.com', '9450904', 'sjhdsjdh', '', '2025-03-25', 'morning', 'pending', '2025-03-24 03:51:52.689357', '2025-03-24 03:51:52.689357', 12, 66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(106, 'sdhjd', 'gsgg@gmail.com', '96595869', 'hdghghdg', '', '2025-03-25', 'afternoon', 'pending', '2025-03-24 03:56:22.101802', '2025-03-24 03:56:22.101802', 11, 66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(107, 'xch', 'sdhj@gmail.com', '5859659', 'sssdhgsd', '', '2025-03-28', 'morning', 'claimed', '2025-03-24 03:57:55.919090', '2025-03-26 06:14:07.583010', 15, 67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(108, 'udhj', 'sdhj@gmail.com', '495084', 'shdjsh', '', '2025-03-25', 'afternoon', 'pending', '2025-03-24 03:59:06.878037', '2025-03-24 03:59:06.878037', 12, 67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(109, 'dihfu', 'sdhj@gmail.com', '658905690', 'sjdhjshd', '', '2025-03-26', 'morning', 'pending', '2025-03-24 04:00:05.173821', '2025-03-24 04:00:05.173821', 11, 67, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(110, 'djfh', 'jshduhu@gmail.com', '38403', 'jdhdhsdhjh', '', '2025-03-28', 'afternoon', 'rescheduled', '2025-03-24 04:05:22.897429', '2025-03-24 04:07:51.539890', 15, 68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(111, 'hsghd', 'jshduhu@gmail.com', '8389489384', 'sjdhjshdh', '', '2025-03-27', 'morning', 'rejected', '2025-03-24 04:05:57.863816', '2025-03-25 20:33:48.648456', 12, 68, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(112, 'dhshd', 'sjdhjdsh@gmail.com', '5990590', 'hsdghgsd', '', '2025-03-28', 'afternoon', 'rescheduled', '2025-03-24 04:14:10.853290', '2025-03-24 04:16:04.925675', 15, 69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(113, 'dhshd', 'sjdhjdsh@gmail.com', '5990590', 'hsdghgsd', '', '2025-03-29', 'morning', 'rescheduled', '2025-03-24 04:16:04.882356', '2025-03-24 04:21:13.556029', 15, 69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(114, 'dhshd', 'sjdhjdsh@gmail.com', '5990590', 'hsdghgsd', '', '2025-03-31', 'morning', 'claimed', '2025-03-24 04:21:13.506495', '2025-03-24 04:23:47.482304', 15, 69, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(115, 'sha labang', 'oke@gmail.com', '6979609', 'shdghsghd', '', '2025-03-28', 'afternoon', 'claimed', '2025-03-24 07:13:53.799065', '2025-03-25 20:39:46.931775', 11, 70, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(117, 'student sample', 'student@gmail.com', '9875642', 'Claret School', '', '2025-03-26', 'morning', 'approved', '2025-03-26 03:28:16.843253', '2025-04-12 16:37:56.181274', 11, 71, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(118, 'lakuping vin', 'ceb@gmail.com', '90891892891', 'sample', '', '2025-03-29', 'morning', 'claimed', '2025-03-27 13:07:42.127823', '2025-03-27 14:04:02.329454', 11, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(119, 'sdhsd', 'ceb@gmail.com', '900020334', 'ashjhasjhj', '', '2025-03-28', 'afternoon', 'claimed', '2025-03-27 14:14:59.421641', '2025-03-27 14:50:59.798469', 11, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(120, 'new', 'ceb@gmail.com', '2083092030', 'xchjjxkcjkjkxc', '', '2025-03-28', 'morning', 'pending', '2025-03-27 15:04:14.391017', '2025-03-27 15:04:14.391017', 12, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(121, 'sdsd', 'ceb@gmail.com', 'sdsd', 'dsjksjkd', '', '2025-03-28', 'morning', 'claimed', '2025-03-27 15:38:53.917562', '2025-03-27 23:23:02.330108', 15, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(122, 'dfkdjf', 'ceb@gmail.com', '23029039', 'dfdjfk', '', '2025-03-28', 'morning', 'rescheduled', '2025-03-27 15:39:20.203161', '2025-03-27 23:36:29.685246', 11, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(123, 'dfkdjf', 'ceb@gmail.com', '23029039', 'dfdjfk', '', '2025-04-25', 'morning', 'rescheduled', '2025-03-27 23:36:29.663917', '2025-03-28 00:05:22.555996', 11, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(124, 'dfkdjf', 'ceb@gmail.com', '23029039', 'dfdjfk', '', '2025-04-30', 'morning', 'rescheduled', '2025-03-28 00:05:22.530907', '2025-03-28 00:13:16.045017', 11, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(125, 'dfkdjf', 'ceb@gmail.com', '23029039', 'dfdjfk', '', '2025-05-31', 'afternoon', 'waiting_for_submission', '2025-03-28 00:13:16.045017', '2025-04-29 14:52:56.353281', 11, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(126, 'jgj', 'ple@gmail.com', '09090', 'jjhjhh', '', '2025-03-29', 'afternoon', 'claimed', '2025-03-28 00:15:48.738612', '2025-03-28 00:20:01.203974', 15, 73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(127, 'skdjksjd', 'ple@gmail.com', '0940595', 'sldjosd', '', '2025-04-01', 'morning', 'approved', '2025-03-28 00:21:06.899506', '2025-04-29 15:18:43.037165', 15, 73, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(128, 'fv', 'ceb@gmail.com', '400904', 'vbkjg', '', '2025-04-01', 'morning', 'approved', '2025-03-28 00:22:03.916144', '2025-04-29 15:18:43.023405', 15, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(129, 'sjdhjs', 'df@gmail.com', '0909054598', 'fkfj', '', '2025-04-01', 'morning', 'approved', '2025-03-28 00:24:33.223009', '2025-04-29 15:18:43.005934', 15, 74, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(130, 'dta data', 'data@gmail.com', '00309959089', 'Claret School', '', '2025-04-03', 'morning', 'claimed', '2025-04-02 06:16:21.638698', '2025-04-02 06:21:17.261867', 11, 78, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(131, 'hakdog hakdogin', 'hakdog@gmail.com', '329784578', 'Pilar College', '', '2025-04-03', 'morning', 'approved', '2025-04-02 06:43:53.194460', '2025-04-29 15:18:42.986742', 11, 79, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(132, 'Rj Toribio', 'rj@gmail.com', '090979797979', 'Pilar college', '', '2025-04-22', 'afternoon', 'claimed', '2025-04-02 09:49:29.503241', '2025-04-02 09:50:08.429610', 11, 81, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 0),
(133, 'Rj Toribio', 'lakuping@gmail.com', '090979797979', 'Pilar college', '', '2025-04-23', 'afternoon', 'claimed', '2025-04-07 08:47:06.227385', '2025-04-10 19:31:20.052502', 11, 82, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(134, 'lakuping kalvin salim', '222222@gmail.com', '09123456789', 'ZAMBOANGA CITY WEST', '', '2025-04-11', 'afternoon', 'claimed', '2025-04-07 09:09:55.354230', '2025-04-07 09:17:27.491226', 11, 88, 22, 'senior_high_graduating', '33', '00', '33', 'Filipiono', NULL, NULL, 'male', '22222', 'Taluksangay', 1, 'BALIWASAN ROAD 123', '2018', NULL, 0, NULL, NULL, NULL, NULL, 0),
(135, 'lakuping kalvin salim', 'xt202000397@wmsu.edu.ph', '09123456789', 'hshshhshhshs', '', '2025-04-18', 'morning', 'approved', '2025-04-07 09:14:29.318277', '2025-04-29 15:18:42.788549', 11, 89, 22, 'senior_high_graduate', '33', '00', '33', 'Filipiono', NULL, NULL, 'male', '22222', 'Taluksangay', 1, 'shhshhshs', 'hshhshhs', NULL, 0, 1, NULL, NULL, NULL, 0),
(136, 'lakuping kalvin salim', 'xt202000397@wmsu.edu.ph', '09123456789', 'hshshhshhshs', '', '2025-04-18', 'morning', 'waiting_for_submission', '2025-04-07 09:18:29.883316', '2025-04-29 14:33:15.670198', 12, 89, 22, 'senior_high_graduate', '33', '00', '33', 'Filipiono', '', '', 'male', '22222', 'Taluksangay', 1, 'Taluksangay', 'hshhshhs', NULL, 0, 1, NULL, NULL, NULL, 0),
(137, 'lakuping kalvin salim', 'xt202000397@wmsu.edu.ph', '09123456789', 'ZAMBOANGA CITY WEST', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-07 09:24:49.483194', '2025-04-29 15:18:42.705177', 15, 89, 22, 'senior_high_graduating', '33', '00', '33', 'Filipiono', '', '', 'male', '22222', 'Taluksangay', 1, 'BALIWASAN ROAD 123', '2018', NULL, 0, 1, NULL, NULL, NULL, 0),
(138, 'lakuping kalvin salim', 'jing@gmail.com', '09123456789', 'hshshhshhshs', '', '2025-04-25', 'morning', 'approved', '2025-04-07 09:38:11.220892', '2025-04-29 15:18:42.769207', 11, 90, 22, 'senior_high_graduate', '33', '00', '33', 'Filipiono', '', '', 'male', '22222', 'Taluksangay', 1, 'Taluksangay', 'hshhshhs', NULL, 0, 1, NULL, NULL, NULL, 0),
(139, 'lakuping kalvin salim', 'jing@gmail.com', '09123456789', 'hshshhshhshs', '', '2025-04-15', 'morning', 'waiting_for_submission', '2025-04-07 10:02:50.833913', '2025-04-29 14:33:15.688177', 12, 90, 22, 'senior_high_graduate', '33', '00', '33', 'Filipiono', '', '', 'male', '22222', 'Taluksangay', 1, 'Taluksangay', 'hshhshhs', NULL, 0, 1, NULL, NULL, NULL, 0),
(140, 'okeeeeeee lalalaala', 'jjjjj@gmail.com', '090498594757', 'shjhdjahdhhhhdhhjha', '', '2025-04-10', 'morning', 'approved', '2025-04-07 12:35:39.442525', '2025-04-29 15:18:42.955200', 11, 92, 16, 'senior_high_graduating', '09', '06', '2020', 'filipino', '', '', 'male', '123456', 'ggsgdgsgdghsgdgsgghsdghsd', 1, 'abdnbnbdbndnnbdbn', '33', NULL, 0, 1, NULL, NULL, NULL, 0),
(141, 'qq', 'jjjjj@gmail.com', '090569869865', '1211', '', '2025-04-25', 'morning', 'waiting_for_submission', '2025-04-07 12:38:28.413224', '2025-04-29 14:33:15.585913', 12, 92, 22, 'senior_high_graduating', 'qq', 'q', '222', 'filipino', '', '', 'male', '1234', 'msndmmnsmdnm', 1, 'mdmnmsmdmnmdnknnsnd', '12112', NULL, 0, 1, NULL, NULL, NULL, 0),
(142, '222', 'jjjjj@gmail.com', '097373627252', 'skdjksjdkd', '', '2025-04-24', 'morning', 'approved', '2025-04-07 12:49:29.582836', '2025-04-29 15:18:42.867974', 15, 92, 18, 'senior_high_graduate', '09', '03', '2000', 'dsjhhsjhd', '', '', 'male', 'ksjssdkjkdskd', 'hsgdgdhsghd', 1, 'jashjhjhsjhasjh', '20', NULL, 0, 1, NULL, NULL, NULL, 0),
(143, 'kjsdkjdsjsdjksdkkjs', 'vvvv@gmail.com', '09266477222', 'jshdjhasdhj', '', '2025-04-17', 'afternoon', 'waiting_for_submission', '2025-04-07 12:56:39.435609', '2025-04-29 14:43:14.942965', 11, 93, 12, 'senior_high_graduate', '10', '06', '2002', 'filipino', '', '', 'male', '12345', 'ahsdjahsjdh', 1, 'jsdjshajdhhasdh', '300', NULL, 0, 1, NULL, NULL, NULL, 0),
(144, 'allallalallallala', 'vvvv@gmail.com', '099023898398', 'jsahdjddjdhj', '', '2025-04-16', 'afternoon', 'waiting_for_submission', '2025-04-07 13:00:35.015450', '2025-04-29 14:43:14.958314', 15, 93, 20, 'senior_high_graduating', '09', '09', '2002', 'filipino', '', '', 'male', '29393', 'nsbhsjhhsdj', NULL, 'ajshjshhajhsjajssjhsh', '2002', NULL, 0, 1, NULL, NULL, NULL, 0),
(145, 'jfhjshdfhjsfdhjsfhjsfhj', 'vvvv@gmail.com', '09696969699', 'jshdjhsdhjjh', '', '2025-04-16', 'morning', 'waiting_for_submission', '2025-04-07 13:03:50.013292', '2025-04-29 14:33:15.703422', 12, 93, 16, 'senior_high_graduating', '06', '09', '2002', 'filipino', '', '', 'male', '123456', 'jsdjhdjhshdh', 1, 'dhfjhsjjd', '2020', NULL, 0, 1, NULL, NULL, NULL, 0),
(146, 'skjdsdjdjjd jasdkjjfjkdj', 'boiiii@gmail.com', '0987654321', 'dnnjsdnjdnj', '', '2025-04-08', 'morning', 'approved', '2025-04-07 13:09:06.025717', '2025-04-29 15:18:42.970971', 11, 94, 33, 'senior_high_graduating', '20', '06', '2000', 'jasjhd', '', '', 'male', 'jdhjhwjd', 'ashjhd', 1, 'sdsjdjj', '00485', NULL, 0, 1, NULL, NULL, NULL, 0),
(147, 'dhskdkjkakjs', 'boiiii@gmail.com', '095409590', 'kjkdfdfj', '', '2025-04-23', 'morning', 'waiting_for_submission', '2025-04-07 13:27:50.261688', '2025-04-29 14:33:15.651266', 12, 94, 27, 'senior_high_graduate', '06', '09', '2002', 'dnfjjdf', '', '', 'male', 'jdhfjdfj', 'jdfjsdfhhjfdj', 1, 'smdjsdjdjjksd', '00495094', NULL, 0, 1, NULL, NULL, NULL, 0),
(148, 'jfdjfjjjkfdfdjkfdk', 'boiiii@gmail.com', '09609606909', 'ksdjsdsjkd', '', '2025-04-18', 'afternoon', 'waiting_for_submission', '2025-04-07 13:32:16.968101', '2025-04-29 14:43:14.928381', 15, 94, 85, 'senior_high_graduate', '06', '09', '2000', 'ksjdjdjkdkj', '', '', 'male', '33333', 'hjdhshhjjh', 1, 'jsasjasjks', '33', NULL, 0, 1, NULL, NULL, NULL, 0),
(149, 'dnfdfjdjfjjdsjf', 'shdgsdh@gmail.com', '07907979990', 'djsdksjkaskllks', '', '2025-04-11', 'afternoon', 'waiting_for_submission', '2025-04-07 13:35:14.385223', '2025-04-29 14:43:14.968111', 11, 95, 27, 'senior_high_graduating', '20', '06', '2000', 'jshdjhjsd', '', '', 'male', '1234', 'jsadasdjj', 1, 'jnasjnasjjs', '466', NULL, 0, 1, NULL, NULL, NULL, 0),
(150, 'sdhhjshd', 'fggg@gmail.com', '00450590590', 'jsdjhdh', '', '2025-04-25', 'morning', 'waiting_for_submission', '2025-04-07 20:46:43.365423', '2025-04-29 15:18:42.753162', 11, 96, 19, 'senior_high_graduate', '09', '03', '2002', 'filipp', '', '', 'male', '223', 'jadjsdh', 1, 'askdkdjkjak', '2025-08', NULL, 0, 1, NULL, NULL, NULL, 0),
(151, 'rsahid ejrjekrj', 'fggg@gmail.com', '06906909069', 'mdfjdk', '', '2025-04-18', 'afternoon', 'waiting_for_submission', '2025-04-08 06:27:57.681082', '2025-04-29 14:43:14.924112', 15, 96, 89, 'senior_high_graduating', '7', '09', '2000', 'filiperkjel', '', '', 'male', 'hfhdh', 'hghdghgsdghg', 1, 'bhsjdhjwhjhjh', '2025-08', NULL, 0, 1, NULL, NULL, NULL, 0),
(152, 'hsgdhd', 'sdhgsydytsfg@gmail.com', '049504090', 'jsdhhshd', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-09 03:49:03.294472', '2025-04-29 15:18:42.602918', 15, 98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(153, 'jshhsdhjhjsd', 'nnnnnnnn@gmail.com', '9999999999', 'udshus', '', '2025-04-22', 'afternoon', 'waiting_for_submission', '2025-04-09 03:57:33.647128', '2025-04-29 14:43:14.918913', 15, 99, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(154, 'LAKUPING KALVIN', 'hsdshgds@gmail.com', '09455459598', 'HGSHDGASGD', '', '2025-04-17', 'afternoon', 'waiting_for_submission', '2025-04-09 14:31:50.654954', '2025-04-29 14:43:14.937900', 11, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(155, 'LAKUPING KALVIN', 'hsdshgds@gmail.com', '09455459598', 'q', '', '2025-04-24', 'morning', 'approved', '2025-04-09 15:09:51.990027', '2025-04-29 15:18:42.856186', 15, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(156, 'LAKUPING KALVIN', 'hsdshgds@gmail.com', '09455459598', 'jsdhhshd', '', '2025-04-17', 'morning', 'waiting_for_submission', '2025-04-09 15:22:11.209245', '2025-04-29 15:18:42.687277', 12, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(157, 'LAKUPING KALVIN', 'shdgsgd@gmail.com', '09455459598', 'jsdhhshd', '', '2025-04-26', 'morning', 'waiting_for_submission', '2025-04-09 15:33:11.198919', '2025-04-29 15:18:42.650429', 11, 101, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0, 1, NULL, NULL, NULL, 0),
(158, 'LAKUPING KALVIN', 'shdgsgd@gmail.com', '09455459598', 'jsdhhshd', '', '2025-04-23', 'morning', 'waiting_for_submission', '2025-04-09 15:47:07.345916', '2025-04-29 15:18:42.655690', 15, 101, 22, 'senior_high_graduating', '04', '02', '2020', 'Filipiono', '', '', 'male', '3334', 'HSDGSGDGGH', 1, 'BALIWASAN ROAD 123', '2018', 0, 0, 1, NULL, NULL, NULL, 0),
(159, 'LAKUPING KALVIN', 'shdgsgd@gmail.com', '09455459598', 'jsdhhshd', '', '2025-04-26', 'morning', 'waiting_for_submission', '2025-04-09 15:51:57.437570', '2025-04-29 15:18:42.618740', 12, 101, 22, 'senior_high_graduating', '04', '02', '2020', 'Filipiono', '', '', 'male', '3334', 'HSDGSGDGGH', 1, 'BALIWASAN ROAD 123', '2018', 0, 0, 1, NULL, NULL, NULL, 0),
(160, 'lakuping kalvin salim', 'smdshdjh@gmail.com', '09123456789', 'qq', '', '2025-04-24', 'morning', 'approved', '2025-04-09 15:58:20.055431', '2025-04-29 15:18:42.836104', 11, 102, 22, 'senior_high_graduating', '06', '04', '2022', 'Filipiono', '', '', 'male', '1111', 'Taluksangay', 1, 'HSDGSGDGGH', '222', 0, 0, 1, NULL, NULL, NULL, 0),
(161, 'lakuping kalvin salim', 'smdshdjh@gmail.com', '09123456789', 'qq', '', '2025-04-14', 'morning', 'waiting_for_submission', '2025-04-09 16:01:33.101234', '2025-04-29 14:33:15.719102', 12, 102, 22, 'senior_high_graduating', '06', '04', '2022', 'Filipiono', '', '', 'male', '1111', 'Taluksangay', 1, 'HSDGSGDGGH', '222', 0, 0, 1, NULL, NULL, NULL, 0),
(162, 'lakuping kalvin salim', 'smdshdjh@gmail.com', '09123456789', 'jsdhhshd', '', '2025-04-19', 'morning', 'waiting_for_submission', '2025-04-09 16:09:56.022091', '2025-04-29 15:18:42.671542', 15, 102, 22, 'senior_high_graduating', '06', '04', '2022', 'Filipiono', '', '', 'male', '1111', 'Taluksangay', 1, 'BALIWASAN ROAD 123', '2018', 0, 0, 1, NULL, NULL, NULL, 0),
(163, 'BBBB', 'nmnm@gmail.com', '888888888', 'sssjjjjs', '', '2025-04-25', 'morning', 'waiting_for_submission', '2025-04-09 16:20:10.963869', '2025-04-29 15:18:42.737094', 15, 103, 10, 'senior_high_graduate', '18', '10', '2010', 'Filipiono', '', '', 'male', '1111', 'Taluksangay', 1, 'HSDGSGDGGH', '222', 0, 0, 1, NULL, NULL, NULL, 0),
(164, 'hghgh', 'nmnm@gmail.com', '09455459598', 'HGSHDGASGD', '', '2025-04-24', 'morning', 'waiting_for_submission', '2025-04-09 17:40:14.322055', '2025-04-29 14:33:15.635239', 12, 103, 15, 'senior_high_graduating', '12', '06', '2011', 'GGGGGG', '', '', 'male', '3334', 'HSDGSGDGGH', 1, 'GDSGYDGSD', '222', 0, 0, 1, NULL, NULL, NULL, 0),
(165, 'ghjhhjahshahjshj', 'nmnm@gmail.com', '0909090293090', 'SHS BALIWASAN', '', '2025-04-23', 'morning', 'claimed', '2025-04-10 06:48:37.077404', '2025-04-10 06:51:30.397936', 11, 103, 20, 'senior_high_graduating', '04', '06', '1983', 'Filipiono', '', '', 'male', '1111', 'BALLLALALALLA', 1, 'TALUKSANGAY ZAMBOANGA CITY', '2002', 0, 0, NULL, NULL, NULL, NULL, 0),
(166, 'sdhwh', 'nmnm@gmail.com', '0909090293090', 'sjdh', '', '2025-04-16', 'afternoon', 'claimed', '2025-04-10 06:53:02.831917', '2025-04-10 06:54:48.913241', 11, 103, 20, 'senior_high_graduate', '04', '06', '1983', 'Filipiono', '', '', 'male', '1111', 'BALLLALALALLA', 1, 'sdui', '2025-04-24', 0, 0, NULL, NULL, NULL, NULL, 0),
(167, 'sdhwh', 'nmnm@gmail.com', '0909090293090', 'kejdkjskdjidj', '', '2025-04-25', 'morning', 'waiting_for_submission', '2025-04-10 06:55:45.518444', '2025-04-29 15:18:42.721186', 11, 103, 20, 'college', '04', '06', '1983', 'Filipiono', 'bcs', 'wmsu_main', 'male', '1111', 'BALLLALALALLA', 1, 'isajdiajid', '', 0, 0, 1, NULL, NULL, NULL, 0),
(168, 'Labang hudhaifa A', 'ff@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-24', 'morning', 'waiting_for_submission', '2025-04-10 17:35:01.184749', '2025-04-29 14:39:58.590306', 11, 104, 23, 'senior_high_graduating', '15', '03', '2002', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-26', 0, 0, 1, NULL, NULL, NULL, 0),
(169, 'Labang hudhaifa A', 'hg@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-23', 'afternoon', 'claimed', '2025-04-10 17:49:22.652611', '2025-04-10 19:28:54.655155', 11, 105, 23, 'senior_high_graduating', '15', '03', '2002', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-26', 0, 0, 1, NULL, NULL, NULL, 0),
(170, 'Labang hudhaifa A', 'hg@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-18', 'morning', 'approved', '2025-04-10 17:55:25.688586', '2025-04-29 15:18:42.905365', 12, 105, 23, 'senior_high_graduating', '15', '03', '2002', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-26', 0, 0, 1, NULL, NULL, NULL, 0),
(171, 'Labang hudhaifa A', 'hg@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-17', 'morning', 'approved', '2025-04-10 18:11:43.038349', '2025-04-29 15:18:42.921883', 15, 105, 23, 'senior_high_graduating', '15', '03', '2002', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-12', 0, 0, 1, NULL, NULL, NULL, 0),
(172, 'Labang hudhaifa A', 'hg@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-24', 'afternoon', 'claimed', '2025-04-10 18:17:04.452560', '2025-04-10 19:28:54.615210', 11, 105, 23, 'senior_high_graduating', '15', '03', '2002', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-19', 0, 0, 1, NULL, NULL, NULL, 0),
(173, 'Labang hudhaifa A', 'hg@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-18', 'morning', 'claimed', '2025-04-10 18:23:49.512636', '2025-04-10 19:28:54.715239', 11, 105, 23, 'senior_high_graduating', '15', '03', '2002', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(174, 'Labang hudhaifa A', 'hg@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-10 18:34:42.637298', '2025-04-29 14:39:58.571963', 11, 105, 23, 'senior_high_graduating', '15', '03', '2002', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-18', 0, 0, 1, NULL, NULL, NULL, 0),
(175, 'Rj Toribio', 'sgdhghg@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-16', 'afternoon', 'claimed', '2025-04-10 19:08:08.310940', '2025-04-10 19:31:35.240491', 11, 106, 23, 'senior_high_graduating', '14', '04', '1970', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(176, 'Rj Toribio', 'sgdhghg@gmail.com', '+6390979797979', 'SDHGHDGGDH', '', '2025-04-19', 'afternoon', 'claimed', '2025-04-10 19:36:23.293058', '2025-04-10 19:46:24.869706', 11, 106, 23, 'senior_high_graduate', '14', '04', '1970', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'wjhhjjjjjjjjhj', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(177, 'Kalvin Alain lakuping', 'sgdhghg@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-10 19:47:18.085232', '2025-04-29 14:39:58.563922', 11, 106, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(178, 'lsajdljdsjkajkdj', 'jshdhdjh@gmail.com', '0908989787', 'jyasyjysyysiuy', '', '2025-04-24', 'morning', 'approved', '2025-04-12 06:53:43.565770', '2025-04-29 15:18:42.820466', 11, 107, 15, 'senior_high_graduating', '12', '09', '2017', 'filipino', '', '', 'male', '254161', 'jasgdgsdghashd', 1, 'skhkdjhsdh', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(179, 'sdhhshdghgsd', 'hdghghgdh@gmail.com', '09095609509', 'dghdg', '', '2025-04-23', 'afternoon', 'waiting_for_submission', '2025-04-12 07:19:56.637561', '2025-04-29 14:43:14.910310', 11, 108, 10, 'senior_high_graduating', '06', '09', '1968', 'filipino', '', '', 'male', '967969', 'sgsgddsghhsgd', 1, 'jshdjhs', '2025-04-18', 0, 0, 1, NULL, NULL, NULL, 0),
(180, 'djhfjhdfsndhhshd', 'jshdjhsdjh@gmail.com', '09454757889', 'sjhdjs', '', '2025-04-16', 'afternoon', 'waiting_for_submission', '2025-04-12 07:29:34.577828', '2025-04-29 14:43:14.951367', 11, 109, 24, 'senior_high_graduating', '12', '05', '2007', 'filipino', '', '', 'female', '38487', 'sdghggdg', 1, 'shds', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(181, 'Kalvin Alain lakuping', 'jhshdhs@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-04-23', 'morning', 'claimed', '2025-04-12 16:13:01.055713', '2025-04-12 16:36:28.052299', 11, 110, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-01', 0, 0, 1, NULL, NULL, NULL, 0);
INSERT INTO `base_appointment` (`id`, `full_name`, `email`, `contact_number`, `school_name`, `college_level`, `preferred_date`, `time_slot`, `status`, `created_at`, `updated_at`, `program_id`, `user_id`, `age`, `applicant_type`, `birth_day`, `birth_month`, `birth_year`, `citizenship`, `college_course`, `college_type`, `gender`, `high_school_code`, `home_address`, `is_first_time`, `school_address`, `school_graduation_date`, `times_taken`, `is_submitted`, `test_center_id`, `test_room_id`, `test_session_id`, `assigned_test_time_slot`, `is_time_slot_modified`) VALUES
(182, 'Labang hudhaifa A', 'jhshdhs@gmail.com', '0952625161', 'SDHGHDGGDH', '', '2025-04-23', 'afternoon', 'waiting_for_submission', '2025-04-12 16:37:15.278438', '2025-04-29 14:43:14.902246', 11, 110, 23, 'senior_high_graduate', '15', '04', '1966', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'wjhhjjjjjjjjhj', '2025-04-23', 0, 0, 1, NULL, NULL, NULL, 0),
(183, 'Labang hudhaifa A', 'jsdhshgdh@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-16', 'morning', 'claimed', '2025-04-12 17:15:58.855910', '2025-04-12 17:24:50.214818', 11, 111, 23, 'senior_high_graduating', '15', '04', '1966', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-30', 0, 0, NULL, NULL, NULL, NULL, 0),
(184, 'Labang hudhaifa A', 'jsdhshgdh@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-16', 'afternoon', 'claimed', '2025-04-12 17:25:24.667850', '2025-04-12 17:33:10.124732', 11, 111, 23, 'senior_high_graduating', '15', '04', '1966', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(185, 'Labang hudhaifa A', 'jsdhshgdh@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-12 17:29:42.081289', '2025-04-29 14:39:58.557929', 12, 111, 23, 'senior_high_graduating', '15', '04', '1966', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(186, 'Labang hudhaifa A', 'jsdhshgdh@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-18', 'morning', 'claimed', '2025-04-12 17:34:16.196725', '2025-04-12 17:49:42.834171', 11, 111, 23, 'senior_high_graduating', '15', '04', '1966', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-14', 0, 0, 1, NULL, NULL, NULL, 0),
(187, 'Labang hudhaifa A', 'jsdhshgdh@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-29', 'morning', 'waiting_for_submission', '2025-04-12 17:43:04.790687', '2025-04-29 14:39:58.577016', 15, 111, 23, 'senior_high_graduating', '15', '04', '1966', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-21', 0, 0, 1, NULL, NULL, NULL, 0),
(188, 'Labang hudhaifa A', 'jsdhshgdh@gmail.com', '0952625161', 'SDHGHDGGDH', '', '2025-04-29', 'morning', 'waiting_for_submission', '2025-04-12 17:50:46.824438', '2025-04-29 14:39:58.494311', 11, 111, 23, 'senior_high_graduate', '15', '04', '1966', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'wjhhjjjjjjjjhj', '2025-04-16', 0, 0, 1, NULL, NULL, NULL, 0),
(189, 'Labang hudhaifa A', 'sdjsdj@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-23', 'morning', 'waiting_for_submission', '2025-04-12 18:12:04.967917', '2025-04-29 14:39:58.595548', 11, 112, 23, 'senior_high_graduating', '15', '04', '1966', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-15', 0, 0, 1, NULL, NULL, NULL, 0),
(190, 'sha labang', 'sdjsdj@gmail.com', '+636979609', 'Asia Academic School', '', '2025-04-15', 'morning', 'approved', '2025-04-13 14:21:55.099762', '2025-04-29 15:18:42.938552', 15, 112, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(191, 'Rj Toribio', 'sdjsdj@gmail.com', '+6390979797979', 'SDHGHDGGDH', '', '2025-04-24', 'morning', 'claimed', '2025-04-13 14:31:27.339690', '2025-04-13 14:37:48.644960', 12, 112, 23, 'senior_high_graduate', '14', '10', '2009', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'wjhhjjjjjjjjhj', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(192, 'Rj Toribio', 'sdjsdj@gmail.com', '+6390979797979', 'SDHGHDGGDH', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-13 15:03:02.214485', '2025-04-29 14:39:58.484999', 12, 112, 23, 'senior_high_graduate', '14', '10', '2009', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'wjhhjjjjjjjjhj', '2025-04-15', 0, 0, 1, NULL, NULL, NULL, 0),
(193, 'Labang hudhaifa A', 'nnnnnnnn@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-24', 'morning', 'waiting_for_submission', '2025-04-14 01:07:19.598925', '2025-04-29 14:39:58.585255', 11, 99, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-15', 0, 0, 1, NULL, NULL, NULL, 0),
(194, 'lakuping kalvin salim', 'shdjhsdhh@gmail.com', '09454757889', 'taluksangay national high school', '', '2025-04-23', 'morning', 'approved', '2025-04-14 19:06:56.924119', '2025-04-29 15:18:42.883650', 11, 113, 28, 'senior_high_graduating', '15', '02', '2000', 'filipino', '', '', 'male', '126194', 'taluksan zamboanga city', 1, 'taluksanagay zamboanga city', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(195, 'lsajdljdsjkajkdj', 'shdjhsdhh@gmail.com', '02830820484', 'taluksangay national high school', '', '2025-04-25', 'morning', 'waiting_for_submission', '2025-04-14 19:10:37.184511', '2025-04-14 19:19:45.765353', 15, 113, 15, 'senior_high_graduating', '06', '01', '2000', 'filipino', '', '', 'male', '126194', 'sgsgddsghhsgd', 1, 'taluksanagay zamboanga city', '2025-04-16', 0, 0, 1, NULL, NULL, NULL, 0),
(196, 'lakuping kalvin salim', 'shdjhsdhh@gmail.com', '09454757889', 'taluksangay national high school', '', '2025-04-26', 'afternoon', 'waiting_for_submission', '2025-04-14 19:19:18.651369', '2025-04-14 19:19:45.748702', 12, 113, 16, 'senior_high_graduating', '10', '04', '2003', 'filipino', '', '', 'male', '38487', 'taluksan zamboanga city', 1, 'taluksanagay zamboanga city', '2025-04-16', 0, 0, 1, NULL, NULL, NULL, 0),
(197, 'Alfahad Tahil', 'alfahad@gmail.com', '09454757889', 'Zamboanga City Main', '', '2025-04-18', 'afternoon', 'waiting_for_submission', '2025-04-16 05:03:02.368681', '2025-04-16 05:04:43.052909', 11, 114, 25, 'senior_high_graduate', '16', '04', '1998', 'Filipino', '', '', 'male', '123456', 'Baliwasan Zamboanga City', 1, 'Tetuan Zamboanga City', '2022-06-20', 0, 0, 1, NULL, NULL, NULL, 0),
(198, 'labang dhaif', 'name@gmail.com', '0935267372', 'Zamboanga city main', '', '2025-04-25', 'afternoon', 'waiting_for_submission', '2025-04-16 14:00:59.913691', '2025-04-16 14:06:59.406254', 11, 115, 23, 'senior_high_graduating', '14', '04', '2002', 'Filipino', '', '', 'male', '123456', 'Guiwan Zamboanga City', 1, 'Tetuan Zamboanga City', '2025-04-18', 0, 0, 1, NULL, NULL, NULL, 0),
(199, 'Labang Dhaif', 'labang3@gmail.com', '0935267372', 'Zamboanga city main', '', '2025-04-23', 'afternoon', 'waiting_for_submission', '2025-04-16 14:54:54.162586', '2025-04-16 15:01:05.814238', 11, 116, 22, 'senior_high_graduating', '12', '02', '2001', 'Filipino', '', '', 'male', '123456', 'Guiwan Zamboanga City', 1, 'Tetuan Zamboanga City', '2025-04-03', 0, 0, 1, NULL, NULL, NULL, 0),
(200, 'Labang hudhaifa A', 'hsgdhgshdg@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-19', 'afternoon', 'rescheduled', '2025-04-18 08:49:35.387646', '2025-04-18 09:10:49.149714', 11, 117, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(201, 'Labang hudhaifa A', 'hsgdhgshdg@gmail.com', '0952625161', 'SDHGHDGGDH', '', '2025-04-24', 'morning', 'waiting_for_submission', '2025-04-18 09:07:00.289529', '2025-04-18 09:07:20.473974', 12, 117, 23, 'senior_high_graduate', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'wjhhjjjjjjjjhj', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(202, 'Rj Toribio', 'hsgdhgshdg@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-29', 'morning', 'waiting_for_submission', '2025-04-18 09:08:25.407833', '2025-04-18 09:08:46.568250', 15, 117, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(203, 'Labang hudhaifa A', 'hsgdhgshdg@gmail.com', '0952625161', 'Asia Academic School', '', '2025-04-30', 'afternoon', 'rescheduled', '2025-04-18 09:10:49.117017', '2025-04-29 14:39:43.494807', 11, 117, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(204, 'Rj Toribio', 'jshdshdsg@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-30', 'morning', 'submitted', '2025-04-18 09:12:23.248522', '2025-04-19 02:50:28.782421', 11, 118, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(205, 'Rj Toribio', 'hsdghgshdgg@gmail.com', '+6390979797979', 'SDHGHDGGDH', '', '2025-04-26', 'afternoon', 'waiting_for_submission', '2025-04-18 09:17:28.825363', '2025-04-18 09:18:04.462029', 11, 119, 23, 'senior_high_graduate', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'sjds', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(206, 'Rj Toribio', 'hsdghgshdgg@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-18 09:22:52.910645', '2025-04-18 09:32:04.467546', 12, 119, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(207, 'Rj Toribio', 'hdhgdh@gmail.com', '+6390979797979', 'SDHGHDGGDH', '', '2025-04-24', 'morning', 'waiting_for_submission', '2025-04-18 09:30:17.780611', '2025-04-18 09:32:04.500191', 11, 120, 23, 'senior_high_graduate', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'sjds', '2025-04-23', 0, 0, 1, NULL, NULL, NULL, 0),
(208, 'Rj Toribio', 'hdhgdh@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-30', 'morning', 'submitted', '2025-04-18 09:33:57.599133', '2025-04-27 15:03:20.993268', 12, 120, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-23', 0, 0, 1, NULL, NULL, NULL, 0),
(209, 'Rj Toribio', 'jsdhshd@gmail.com', '+6390979797979', 'SDHGHDGGDH', '', '2025-04-30', 'afternoon', 'submitted', '2025-04-18 10:24:19.794501', '2025-04-27 15:03:07.690249', 11, 121, 23, 'senior_high_graduate', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'sjds', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(210, 'Rj Toribio', 'jsdhshd@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-30', 'morning', 'submitted', '2025-04-18 10:27:12.745032', '2025-04-27 14:59:31.425841', 12, 121, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(211, 'Rj Toribio', 'jsdhshd@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-29', 'morning', 'waiting_for_submission', '2025-04-18 10:34:10.246800', '2025-04-18 10:37:31.727290', 15, 121, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(212, 'Rj Toribio', 'shdhsduh@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-29', 'afternoon', 'waiting_for_submission', '2025-04-18 10:38:55.370177', '2025-04-18 10:39:19.880711', 11, 122, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-19', 0, 0, 1, NULL, NULL, NULL, 0),
(213, 'Rj Toribio', 'shdhsduh@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-25', 'morning', 'waiting_for_submission', '2025-04-18 10:40:08.297304', '2025-04-18 10:40:27.323899', 12, 122, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-19', 0, 0, 1, NULL, NULL, NULL, 0),
(214, 'Rj Toribio', 'shdhsduh@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-26', 'afternoon', 'waiting_for_submission', '2025-04-18 10:41:22.517451', '2025-04-18 10:41:33.274341', 15, 122, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-19', 0, 0, 1, NULL, NULL, NULL, 0),
(215, 'Rj Toribio', 'sdgus@gmail.com', '+6390979797979', 'SDHGHDGGDH', '', '2025-04-26', 'morning', 'waiting_for_submission', '2025-04-18 10:47:25.307748', '2025-04-18 10:47:41.719458', 11, 123, 23, 'senior_high_graduate', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'sjds', '2025-04-19', 0, 0, 1, NULL, NULL, NULL, 0),
(216, 'Rj Toribio', 'sdgus@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-19', 'morning', 'waiting_for_submission', '2025-04-18 10:52:30.977047', '2025-04-18 10:52:47.714941', 12, 123, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-18', 0, 0, 1, NULL, NULL, NULL, 0),
(217, 'Rj Toribio', 'sdgus@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-29', 'morning', 'waiting_for_submission', '2025-04-18 10:57:50.374025', '2025-04-18 10:58:03.441480', 15, 123, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(218, 'Rj Toribio', 'sudsuds@gmail.com', '+6390979797979', 'SDHGHDGGDH', '', '2025-04-25', 'morning', 'waiting_for_submission', '2025-04-18 11:09:44.101712', '2025-04-18 11:10:08.027767', 11, 124, 23, 'senior_high_graduate', '06', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'sjds', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(219, 'Rj Toribio', 'sudsuds@gmail.com', '+6390979797979', 'SDHGHDGGDH', '', '2025-04-26', 'morning', 'waiting_for_submission', '2025-04-18 11:16:09.322247', '2025-04-18 11:16:23.083401', 12, 124, 23, 'senior_high_graduate', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'sjds', '2025-04-19', 0, 0, 1, NULL, NULL, NULL, 0),
(220, 'Rj Toribio', 'sudsuds@gmail.com', '+6390979797979', 'Asia Academic School', '', '2025-04-26', 'morning', 'waiting_for_submission', '2025-04-18 11:27:20.936842', '2025-04-18 11:27:39.784054', 15, 124, 23, 'senior_high_graduating', '14', '04', '2017', 'Filipino', '', '', 'male', '12345678', 'wjhhjjjjjjjjhj', 1, 'Tetuan Zamboanga City', '2025-04-19', 0, 0, 1, NULL, NULL, NULL, 0),
(221, 'Kalvin Alain lakuping', 'jshjdhsh@gmail.como', '+6509072656256', 'Asia Academic School', '', '2025-04-19', 'morning', 'waiting_for_submission', '2025-04-19 02:40:20.184580', '2025-04-19 02:40:43.793992', 11, 125, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(222, 'Kalvin Alain lakuping', 'shuhsydh@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-04-26', 'morning', 'waiting_for_submission', '2025-04-19 02:59:18.439177', '2025-04-19 02:59:57.551252', 11, 126, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(223, 'Kalvin Alain lakuping', 'sdhsdjh@gmail.com', '+6509072656256', 'SDHGHDGGDH', '', '2025-04-25', 'morning', 'waiting_for_submission', '2025-04-19 03:10:32.281692', '2025-04-19 03:10:52.669089', 11, 127, 23, 'senior_high_graduate', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'sjds', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(224, 'Kalvin Alain lakuping', 'sdhsdjh@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-04-29', 'morning', 'waiting_for_submission', '2025-04-19 03:12:24.854911', '2025-04-19 03:13:26.285699', 12, 127, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(225, 'Kalvin Alain lakuping', 'sdhsdjh@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-04-25', 'morning', 'waiting_for_submission', '2025-04-19 03:17:49.832910', '2025-04-19 03:18:41.576447', 15, 127, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(226, 'Kalvin Alain lakuping', 'gashghasg@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-04-23', 'morning', 'waiting_for_submission', '2025-04-19 03:24:58.087685', '2025-04-19 03:31:56.148745', 11, 128, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(227, 'Kalvin Alain lakuping', 'shdghsgdg@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-04-29', 'afternoon', 'waiting_for_submission', '2025-04-19 06:56:39.176745', '2025-04-19 06:59:54.494513', 11, 129, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(228, 'Kalvin Alain lakuping', 'shdghsgdg@gmail.com', '+6509072656256', 'SDHGHDGGDH', '', '2025-04-29', 'afternoon', 'waiting_for_submission', '2025-04-19 07:00:27.204323', '2025-04-19 07:00:51.850838', 15, 129, 23, 'senior_high_graduate', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'sjds', '2025-04-25', 0, 0, 1, NULL, NULL, NULL, 0),
(229, 'sdjhsdj', 'shdjhhd@gmail.com', '0956958698', 'Asia Academic School', '', '2025-04-23', 'afternoon', 'waiting_for_submission', '2025-04-20 06:46:02.662100', '2025-04-20 06:47:42.367381', 11, 130, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(230, 'sdjhsdj', 'shdjhhd@gmail.com', '0956958698', 'Asia Academic School', '', '2025-04-24', 'afternoon', 'waiting_for_submission', '2025-04-20 07:34:35.920763', '2025-04-20 07:37:38.498541', 12, 130, 23, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '12345678', 'Taluksangay', 1, 'Tetuan Zamboanga City', '2025-04-22', 0, 0, 1, NULL, NULL, NULL, 0),
(231, 'Lakuping Kalvin Salim A', 'lakuping3@gmail.com', '0986362637', 'Asia Academic School', '', '2025-04-26', 'afternoon', 'submitted', '2025-04-20 09:55:45.151275', '2025-04-20 09:56:35.997976', 11, 131, 20, 'senior_high_graduating', '10', '06', '2020', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-23', 0, 0, 1, NULL, NULL, NULL, 0),
(232, 'Mones Julma A', 'mones@gmail.com', '0986362637', 'Asia Academic School', '', '2025-04-23', 'afternoon', 'submitted', '2025-04-20 11:24:04.023452', '2025-04-20 11:27:05.501462', 11, 132, 20, 'senior_high_graduating', '10', '06', '2020', 'Filipino', '', '', 'male', '12345678', 'Guiwan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-20', 0, 0, 1, NULL, NULL, NULL, 0),
(233, 'lakuping kalvin salim', 'smdhjhsd@gmail.com', '09454757889', 'taluksangay national high school', '', '2025-04-28', 'morning', 'waiting_for_submission', '2025-04-27 13:50:00.479189', '2025-04-27 14:52:59.376783', 11, 133, 23, 'senior_high_graduating', '10', '03', '2002', 'Filipino', '', '', 'male', '12345', 'taluksan zamboanga city', 1, 'taluksanagay zamboanga city', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(234, 'lakuping kalvin salim', 'jshdjhs@gs.com', '09454757889', 'taluksangay national high school', '', '2025-04-29', 'morning', 'waiting_for_submission', '2025-04-27 14:00:42.165855', '2025-04-27 14:52:59.352719', 11, 135, 12, 'senior_high_graduating', '06', '01', '2011', 'Filipino', '', '', 'male', '123456', 'taluksan zamboanga city', 1, 'taluksanagay zamboanga city', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(235, 'lakuping kalvin salim', 'shdjhsj@gmail.com', '09454757889', 'jyasyjysyysiuy', '', '2025-04-29', 'afternoon', 'submitted', '2025-04-27 14:54:07.251062', '2025-04-29 07:17:55.539743', 11, 136, 23, 'senior_high_graduating', '18', '11', '2003', 'filipino', '', '', 'male', '12345', 'taluksan zamboanga city', 1, 'taluksanagay zamboanga city', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(236, 'msbdsd', 'jsjdghsgdh@gmail.com', '09346372121', 'hdggdsggsdj', '', '2025-04-30', 'afternoon', 'submitted', '2025-04-29 06:49:08.292085', '2025-04-29 07:17:53.157668', 11, 140, 12, 'senior_high_graduating', '05', '01', '2002', 'filipino', '', '', 'male', '123456', 'hgsdhgsdg', 1, 'shdjhdsh', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(237, 'msbdsd', 'shdghsgdh@gmail.com', '09346372121', 'hdggdsggsdj', '', '2025-04-30', 'morning', 'submitted', '2025-04-29 07:07:10.742755', '2025-04-29 07:17:50.735456', 11, 141, 12, 'senior_high_graduating', '16', '02', '2002', 'filipino', '', '', 'male', '123456', 'hgsdhgsdg', 1, 'shdjhdsh', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(238, 'sdhuhds', 'sdghgs@gmail.com', '09346372121', 'hdggdsggsdj', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-29 08:19:59.354475', '2025-04-29 08:20:19.310330', 11, 142, 12, 'senior_high_graduating', '10', '01', '2000', 'filipino', '', '', 'male', '123456', 'hgsdhgsdg', 1, 'dfhjdhfjh', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(239, 'sjdhjshdj', 'sdjhjshd@gmail.com', '02938983298', 'jashhswd', '', '2025-04-30', 'afternoon', 'waiting_for_submission', '2025-04-29 09:15:46.961567', '2025-04-29 09:16:59.071040', 11, 143, 30, 'senior_high_graduating', '12', '11', '1995', 'filipino', '', '', 'male', '123456', 'hgsdhgsdg', 1, 'sjdhjshd', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(240, 'sdjhjsdh', 'sdjhjshd@gmail.com', '02938983298', 'hdggdsggsdj', '', '2025-04-30', 'afternoon', 'waiting_for_submission', '2025-04-29 09:19:49.747428', '2025-04-29 09:20:05.190008', 12, 143, 30, 'senior_high_graduating', '13', '02', '2019', 'filipino', '', '', 'male', '12345', 'hgsdhgsdg', 1, 'shdjhdsh', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(241, 'sjhds', 'sdjhjshd@gmail.com', '04509405', 'hdggdsggsdj', '', '2025-05-08', 'morning', 'rescheduled', '2025-04-29 09:42:53.293324', '2025-04-29 14:35:28.219568', 15, 143, 30, 'senior_high_graduating', '15', '10', '1967', 'filipino', '', '', 'male', '1234567', 'hgsdhgsdg', 1, 'shdjhdsh', '2025-04-30', 0, 0, NULL, NULL, NULL, NULL, 0),
(242, 'sdhjshd', 'sdhjsd@gmail.com', '09799487834', 'Asia Academic', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-29 14:39:22.119239', '2025-04-29 14:39:58.473597', 11, 144, 30, 'senior_high_graduating', '08', '07', '2003', 'filipino', '', '', 'male', '12345', 'Taluksangay', 1, 'Tetuan Zamboanga city', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(243, 'sjdhjsdh', 'sdhjsd@gmail.com', '095869832', 'hdggdsggsdj', '', '2025-05-14', 'afternoon', 'rescheduled', '2025-04-29 14:41:52.393377', '2025-04-29 14:56:38.845541', 15, 144, 30, 'senior_high_graduating', '12', '06', '2010', 'filipino', '', '', 'male', '12345', 'Taluksangay', 1, 'sjdhjshd', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(244, 'sdhshdhjhsd', 'jshdjhsd@gmail.com', '02938983298', 'hdggdsggsdj', '', '2025-05-14', 'afternoon', 'waiting_for_submission', '2025-04-29 15:00:29.294798', '2025-04-29 15:01:01.276879', 11, 145, 30, 'senior_high_graduating', '16', '05', '2002', 'filipino', '', '', 'male', '123456', 'Taluksangay', 1, 'Tetuan Zamboanga city', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(245, 'msbdsd', 'jshdjhsd@gmail.com', '02938983298', 'dkddksjdk', '', '2025-04-30', 'morning', 'waiting_for_submission', '2025-04-29 15:02:52.291590', '2025-04-29 15:03:40.687612', 12, 145, 30, 'senior_high_graduate', '04', '04', '2003', 'filipino', '', '', 'male', '123456', 'Taluksangay', 1, 'dsjkjd', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(246, 'sdjhjsd', 'jdhfhdfh@gmail.com', '09346372121', 'sdnjd', '', '2025-07-16', 'afternoon', 'waiting_for_submission', '2025-04-29 15:18:07.353947', '2025-04-29 15:25:42.429978', 11, 146, 30, 'senior_high_graduating', '03', '02', '2022', 'filipino', '', '', 'male', '12345', 'Taluksangay', 1, 'sjdjhjshd', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(247, 'sjhds', 'jdhfhdfh@gmail.com', '04509405', 'hdggdsggsdj', '', '2025-09-10', 'afternoon', 'submitted', '2025-04-29 15:25:40.534250', '2025-06-24 14:36:09.425407', 15, 146, 30, 'senior_high_graduating', '09', '05', '2016', 'filipino', '', '', 'male', '1234567', 'Taluksangay', 1, 'sjdhjshd', '2025-05-01', 0, 0, 1, NULL, NULL, NULL, 0),
(248, 'Hjshjhjhsjdh', 'jsdhjshd@gmail.com', '0934767287', 'Asia Academic', '', '2025-04-30', 'afternoon', 'waiting_for_submission', '2025-04-29 15:28:37.838866', '2025-04-29 15:39:21.325893', 11, 147, 30, 'senior_high_graduating', '10', '06', '2009', 'filipino', '', '', 'male', '12345', 'msdjshjdh', 1, 'Tetuan Zamboanga city', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(249, 'ajshjhshs', 'jsdjhjsd@gmail.com', '09346372121', 'hdggdsggsdj', '', '2025-04-30', 'afternoon', 'waiting_for_submission', '2025-04-29 15:49:35.782186', '2025-04-29 15:49:56.297072', 11, 148, 30, 'senior_high_graduating', '12', '03', '1997', 'filipino', '', '', 'male', '123456', 'Taluksangay', 1, 'Tetuan Zamboanga city', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(250, 'Lakuping', 'jshdhs@gmail.com', '0923676362', 'msndjhd', '', '2025-05-01', 'morning', 'waiting_for_submission', '2025-04-29 16:29:07.329992', '2025-04-29 16:29:33.980959', 11, 149, 14, 'senior_high_graduating', '06', '03', '2011', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'jdhjhsd', '2025-05-08', 0, 0, 1, NULL, NULL, NULL, 0),
(251, 'jdhsjd', 'sjdhjshd@gmail.com', '093984983948', 'sjdhjsd', '', '2025-10-24', 'afternoon', 'submitted', '2025-04-29 16:33:07.006642', '2025-04-29 16:50:24.668937', 11, 150, 7, 'senior_high_graduating', '14', '09', '2006', 'filipino', '', '', 'male', '', 'jdjhsjd', 1, 'sdjsd', '2025-04-23', 0, 0, 1, NULL, NULL, NULL, 0),
(252, 'Lakuping', 'hsdhshd@gmail.com', '0849894898', 'msndjhd', '', '2025-09-10', 'morning', 'rescheduled', '2025-04-29 16:36:27.084751', '2025-04-29 16:57:51.471535', 11, 151, 12, 'senior_high_graduating', '16', '11', '1993', 'filipino', '', '', 'male', '', 'sdjjdhdjhd', 1, 'jdhjhsd', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(253, 'Lakuping', 'hsdhshd@gmail.com', '0849894898', 'msndjhd', '', '2025-05-03', 'morning', 'rescheduled', '2025-04-29 16:57:51.594329', '2025-04-29 17:05:06.711430', 11, 151, 12, 'senior_high_graduating', '16', '11', '1993', 'filipino', '', '', 'male', '', 'sdjjdhdjhd', 1, 'jdhjhsd', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(254, 'Lakuping', 'hsdhshd@gmail.com', '0849894898', 'msndjhd', '', '2025-05-23', 'morning', 'rescheduled', '2025-04-29 17:05:06.773992', '2025-04-29 17:07:02.984273', 11, 151, 12, 'senior_high_graduating', '16', '11', '1993', 'filipino', '', '', 'male', '', 'sdjjdhdjhd', 1, 'jdhjhsd', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(255, 'Lakuping', 'hsdhshd@gmail.com', '0849894898', 'msndjhd', '', '2025-05-22', 'afternoon', 'waiting_for_submission', '2025-04-29 17:07:03.033775', '2025-04-29 17:07:16.169318', 11, 151, 12, 'senior_high_graduating', '16', '11', '1993', 'filipino', '', '', 'male', '', 'sdjjdhdjhd', 1, 'jdhjhsd', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(256, 'Lakupingd', 'jshdjhsdsdh@gmail.com', '0923676362', 'sdnksd', '', '2025-05-01', 'morning', 'rescheduled', '2025-04-29 17:09:16.941380', '2025-04-29 17:16:25.515068', 11, 153, 12, 'senior_high_graduate', '13', '09', '2003', 'filipino', '', '', 'male', '', 'shdjhsd', 1, 'sdhs', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(257, 'Lakuping', 'jshdjhsdsdh@gmail.com', '0923676362', 'msndjhd', '', '2025-05-08', 'afternoon', 'waiting_for_submission', '2025-04-29 17:14:47.717962', '2025-04-29 17:15:19.156720', 12, 153, 11, 'senior_high_graduating', '05', '06', '2008', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'jdhjhsd', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(258, 'Lakupingd', 'jshdjhsdsdh@gmail.com', '0923676362', 'sdnksd', '', '2025-05-30', 'morning', 'rescheduled', '2025-04-29 17:16:25.563722', '2025-04-29 17:28:18.267857', 11, 153, 12, 'senior_high_graduate', '13', '09', '2003', 'filipino', '', '', 'male', '', 'shdjhsd', 1, 'sdhs', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(259, 'Lakupingd', 'jshdjhsdsdh@gmail.com', '0923676362', 'sdnksd', '', '2025-05-31', 'morning', 'rescheduled', '2025-04-29 17:28:18.306343', '2025-04-29 17:39:31.250281', 11, 153, 12, 'senior_high_graduate', '13', '09', '2003', 'filipino', '', '', 'male', '', 'shdjhsd', 1, 'sdhs', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(260, 'Lakupingd', 'jshdjhsdsdh@gmail.com', '0923676362', 'sdnksd', '', '2025-06-10', 'morning', 'rescheduled', '2025-04-29 17:39:31.337965', '2025-04-29 17:47:13.611137', 11, 153, 12, 'senior_high_graduate', '13', '09', '2003', 'filipino', '', '', 'male', '', 'shdjhsd', 1, 'sdhs', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(261, 'Lakupingd', 'jshdjhsdsdh@gmail.com', '0923676362', 'sdnksd', '', '2025-07-24', 'afternoon', 'rescheduled', '2025-04-29 17:47:13.675503', '2025-04-29 19:48:28.586861', 11, 153, 12, 'senior_high_graduate', '13', '09', '2003', 'filipino', '', '', 'male', '', 'shdjhsd', 1, 'sdhs', '2025-04-30', 0, 0, 1, NULL, NULL, NULL, 0),
(262, 'kalvin', 'sdhjhsdhh@gmail.com', '0923676362', 'msndjhd', '', '2025-05-29', 'afternoon', 'rescheduled', '2025-04-29 17:50:18.409902', '2025-04-29 17:56:09.412728', 11, 154, 21, 'senior_high_graduating', '07', '02', '2020', 'filipino', '', '', 'male', '1234', 'shdjhsd', 1, 'sdjsd', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(263, 'kalvin', 'sdhjhsdhh@gmail.com', '0923676362', 'msndjhd', '', '2025-05-23', 'afternoon', 'rescheduled', '2025-04-29 17:56:09.435350', '2025-04-29 18:03:58.304940', 11, 154, 21, 'senior_high_graduating', '07', '02', '2020', 'filipino', '', '', 'male', '1234', 'shdjhsd', 1, 'sdjsd', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(264, 'Lakuping', 'sdhjhsdhh@gmail.com', '0923676362', 'sdnksd', '', '2025-05-31', 'afternoon', 'rescheduled', '2025-04-29 18:02:33.188131', '2025-04-29 18:08:59.598256', 12, 154, 12, 'senior_high_graduate', '04', '01', '2014', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'sdhs', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(265, 'kalvin', 'sdhjhsdhh@gmail.com', '0923676362', 'msndjhd', '', '2025-05-28', 'morning', 'waiting_for_submission', '2025-04-29 18:03:58.410208', '2025-04-29 18:04:18.319242', 11, 154, 21, 'senior_high_graduating', '07', '02', '2020', 'filipino', '', '', 'male', '1234', 'shdjhsd', 1, 'sdjsd', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(266, 'Lakuping', 'sdhjhsdhh@gmail.com', '0923676362', 'sdnksd', '', '2025-05-31', 'morning', 'rescheduled', '2025-04-29 18:08:59.647840', '2025-04-29 18:14:36.857689', 12, 154, 12, 'senior_high_graduate', '04', '01', '2014', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'sdhs', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(267, 'Lakuping', 'sdhjhsdhh@gmail.com', '0923676362', 'sdnksd', '', '2025-05-24', 'afternoon', 'rescheduled', '2025-04-29 18:11:32.510645', '2025-04-29 18:13:41.965789', 15, 154, 22, 'senior_high_graduate', '15', '09', '2010', 'filipino', '', '', 'male', '12345', 'jshajhas', 1, 'sdhs', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(268, 'Lakuping', 'sdhjhsdhh@gmail.com', '0923676362', 'sdnksd', '', '2025-06-28', 'afternoon', 'rescheduled', '2025-04-29 18:13:42.000383', '2025-04-29 19:48:46.207166', 15, 154, 22, 'senior_high_graduate', '15', '09', '2010', 'filipino', '', '', 'male', '12345', 'jshajhas', 1, 'sdhs', '2025-04-24', 0, 0, 1, NULL, NULL, NULL, 0),
(269, 'Lakuping', 'sdhjhsdhh@gmail.com', '0923676362', 'sdnksd', '', '2025-05-30', 'morning', 'waiting_for_submission', '2025-04-29 18:14:36.887487', '2025-04-29 18:14:48.090126', 12, 154, 12, 'senior_high_graduate', '04', '01', '2014', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'sdhs', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(270, 'kalvin', 'jsdshd@gmail.com', '0923676362', 'msndjhd', '', '2025-05-06', 'afternoon', 'waiting_for_submission', '2025-04-29 18:16:30.230658', '2025-04-29 18:17:11.794342', 11, 155, 12, 'senior_high_graduating', '12', '11', '2018', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'jdhjhsd', '2025-04-18', 0, 0, 1, NULL, NULL, NULL, 0),
(271, 'Lakuping', 'jsdshd@gmail.com', '0923676362', 'msndjhd', '', '2025-05-30', 'morning', 'waiting_for_submission', '2025-04-29 18:20:33.576098', '2025-04-29 18:21:08.035122', 12, 155, 12, 'senior_high_graduating', '15', '03', '2011', 'filipino', '', '', 'male', '12345', 'jdjhsjd', 1, 'jdhjhsd', '2025-04-26', 0, 0, 1, NULL, NULL, NULL, 0),
(272, 'kalvin', 'jsdshd@gmail.com', '0923676362', 'sdnksd', '', '2025-05-31', 'morning', 'waiting_for_submission', '2025-04-29 18:23:19.429599', '2025-04-29 18:23:53.390158', 15, 155, 22, 'senior_high_graduate', '10', '04', '2023', 'filipino', '', '', 'male', '12345', 'jdjhsjd', 1, 'sdhs', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(273, 'Lakuping', 'jhsahs@gmail.com', '0923676362', 'msndjhd', '', '2025-05-01', 'afternoon', 'waiting_for_submission', '2025-04-29 18:28:18.491118', '2025-04-29 18:29:02.337662', 11, 156, 67, 'senior_high_graduating', '18', '11', '2009', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'jdhjhsd', '2025-04-29', 0, 0, 1, NULL, NULL, NULL, 0),
(274, 'Lakuping', 'jhsahs@gmail.com', '0923676362', 'msndjhd', '', '2025-05-31', 'morning', 'waiting_for_submission', '2025-04-29 18:42:18.561942', '2025-04-29 18:42:53.303066', 12, 156, 13, 'senior_high_graduating', '07', '01', '2018', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'sdjsd', '2025-05-01', 0, 0, 1, NULL, NULL, NULL, 0),
(275, 'kalvin', 'asjasj@gmail.com', '0923676362', 'msndjhd', '', '2025-05-08', 'morning', 'submitted', '2025-04-29 18:59:54.993537', '2025-04-29 19:24:38.468415', 11, 157, 13, 'senior_high_graduating', '17', '11', '2014', 'filipino', '', '', 'male', '12345', 'sdjjdhdjhd', 1, 'jdhjhsd', '2025-04-29', 0, 0, 1, NULL, NULL, 'morning', 1),
(276, 'kalvin', 'asjasj@gmail.com', '0923676362', 'msndjhd', '', '2025-05-28', 'morning', 'submitted', '2025-04-29 19:07:39.806163', '2025-04-29 19:24:22.914394', 12, 157, 12, 'senior_high_graduating', '16', '02', '2009', 'filipino', '', '', 'male', '12345', 'jdjhsjd', 1, 'jdhjhsd', '2025-04-29', 0, 0, 1, NULL, NULL, 'afternoon', 1),
(277, 'Lakuping', 'asjasj@gmail.com', '0923676362', 'sdnksd', '', '2025-05-29', 'morning', 'rescheduled', '2025-04-29 19:14:37.758977', '2025-04-29 19:25:36.824926', 15, 157, 12, 'senior_high_graduate', '04', '01', '2009', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'as', '2025-04-28', 0, 0, 1, NULL, NULL, 'morning', 1),
(278, 'Lakuping', 'asjasj@gmail.com', '0923676362', 'sdnksd', '', '2025-06-09', 'morning', 'waiting_for_submission', '2025-04-29 19:25:36.973834', '2025-04-29 19:25:52.451047', 15, 157, 12, 'senior_high_graduate', '04', '01', '2009', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'as', '2025-04-28', 0, 0, 1, NULL, NULL, 'morning', 1),
(279, 'Lakuping', 'sdhjshdj@gmail.com', '0923676362', 'msndjhd', '', '2025-05-09', 'morning', 'rescheduled', '2025-04-29 19:39:14.578356', '2025-04-29 19:49:59.093443', 11, 158, 12, 'senior_high_graduating', '08', '06', '2020', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'jdhjhsd', '2025-05-01', 0, 0, 1, NULL, NULL, 'afternoon', 1),
(280, 'Lakuping', 'sdhjshdj@gmail.com', '0923676362', 'msndjhd', '', '2025-06-28', 'morning', 'rescheduled', '2025-04-29 19:49:59.187905', '2025-04-29 19:55:20.283437', 11, 158, 12, 'senior_high_graduating', '08', '06', '2020', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'jdhjhsd', '2025-05-01', 0, 0, 1, 17, NULL, 'afternoon', 1),
(281, 'Lakuping', 'sdhjshdj@gmail.com', '0923676362', 'msndjhd', '', '2025-06-30', 'morning', 'rescheduled', '2025-04-29 19:55:20.388841', '2025-04-29 20:06:25.076147', 11, 158, 12, 'senior_high_graduating', '08', '06', '2020', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'jdhjhsd', '2025-05-01', 0, 0, 1, 17, NULL, 'afternoon', 1),
(282, 'Lakuping', 'sdhjshdj@gmail.com', '0923676362', 'msndjhd', '', '2025-07-01', 'afternoon', 'waiting_for_submission', '2025-04-29 20:06:25.163673', '2025-04-29 20:06:44.382387', 11, 158, 12, 'senior_high_graduating', '08', '06', '2020', 'filipino', '', '', 'male', '12345', 'shdjhsd', 1, 'jdhjhsd', '2025-05-01', 0, 0, 1, 17, NULL, 'afternoon', 1),
(283, 'kalvin', 'jshdjhsdj@gmail.com', '0923676362', 'msndjhd', '', '2025-05-08', 'morning', 'waiting_for_submission', '2025-04-29 20:08:42.208919', '2025-04-29 20:09:08.177714', 11, 159, 20, 'senior_high_graduating', '04', '01', '2001', 'filipino', '', '', 'male', '12345', 'jdjhsjd', 1, 'jdhjhsd', '2025-04-30', 0, 0, 1, 17, NULL, 'afternoon', 1),
(284, 'Alfahad Tahil James', 'alfahad3@gmail.com', '0923676362', 'Asia Academic School', '', '2025-05-02', 'morning', 'submitted', '2025-04-29 22:58:06.113170', '2025-04-29 22:59:10.407850', 11, 160, 23, 'senior_high_graduating', '15', '03', '1977', 'Filipino', '', '', 'male', '12345', 'Tetuan Zamboanga city', 1, 'Tetuan Zamboanga City', '2025-04-30', 0, 0, 1, 17, NULL, 'afternoon', 1),
(285, 'Francisco, Francis Vaughn Dauba', 'francis123@gmail.com', '0999999999', 'Claret School of Zamboanga City', '', '2025-05-02', 'morning', 'submitted', '2025-04-30 06:16:01.716129', '2025-04-30 06:38:42.142052', 11, 161, 20, 'senior_high_graduating', '09', '09', '2004', 'Filipino', '', '', 'male', '', 'Ruste Dr., San Jose Cawa-Cawa, Zamboanga City', 1, 'Ruste Dr., San Jose Cawa-Cawa', '2025-04-30', 0, 0, 1, 17, NULL, 'afternoon', 1),
(286, 'Alfahad Credo', 'credo@gmail.com', '09346372121', 'Asia Academic', '', '2025-05-08', 'morning', 'submitted', '2025-05-07 06:49:13.293504', '2025-05-07 07:05:58.581105', 11, 162, 21, 'senior_high_graduating', '06', '03', '2004', 'Filipino', '', '', 'male', '123456', 'baliwasan', 1, 'Tetuan Zamboanga city', '2025-05-29', 0, 0, 1, 17, NULL, 'afternoon', 1),
(287, 'Kalvin Alain lakuping', 'jshdjhsjh@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-05-29', 'morning', 'waiting_for_submission', '2025-05-15 06:26:58.455001', '2025-05-15 06:27:21.502492', 11, 163, 12, 'senior_high_graduating', '03', '02', '2022', 'Filipiono', '', '', 'male', '', 'Taluksangay', 1, 'TALUKSANGAY ZAMBOANGA CITY', '2025-05-22', 0, 0, 1, 17, NULL, 'afternoon', 1),
(288, 'Kalvin Alain lakuping', 'sjdhsdjh@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-05-31', 'morning', 'waiting_for_submission', '2025-05-15 07:08:32.849393', '2025-05-15 07:09:00.550503', 11, 164, 12, 'senior_high_graduating', '03', '02', '2022', 'Filipiono', '', '', 'male', '1234', 'Taluksangay', 1, 'TALUKSANGAY ZAMBOANGA CITY', '2025-05-22', 0, 0, 1, 17, NULL, 'afternoon', 1),
(289, 'Kalvin Alain lakuping', 'jsjhdjhsdjh@gmail.com', '+6509072656256', 'SDHGHDGGDH', '', '2025-05-31', 'afternoon', 'waiting_for_submission', '2025-05-15 07:19:57.296856', '2025-05-15 07:20:12.447090', 11, 165, 12, 'senior_high_graduate', '03', '02', '2022', 'Filipiono', '', '', 'male', '1234', 'Taluksangay', 1, 'TALUKSANGAY ZAMBOANGA CITY', '2025-05-30', 0, 0, 1, 17, NULL, 'afternoon', 1),
(290, 'lakuping, kalvin alain', 'ysdystyy@gmail.com', '+6509072656256', 'Asia Academic', '', '2025-05-29', 'morning', 'waiting_for_submission', '2025-05-15 15:41:16.085910', '2025-05-15 15:42:43.019148', 11, 167, 29, 'senior_high_graduating', '03', '02', '2022', 'Filipino', '', '', 'male', '1234', 'Taluksangay', 1, 'Taluksangay', '2025-05-22', 0, 0, 1, 17, NULL, 'afternoon', 1),
(291, 'lakuping, kalvin alain', 'ysdystyy@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-05-24', 'morning', 'claimed', '2025-05-15 15:49:29.103132', '2025-05-15 15:49:44.371970', 12, 167, 12, 'senior_high_graduating', '04', '03', '2005', 'Filipino', '', '', 'male', '1234', 'Purok 6, Taluksangay, Zamboanga City', 1, 'TALUKSANGAY ZAMBOANGA CITY', '2025-05-23', 0, 0, 1, 17, NULL, 'afternoon', 1),
(292, 'lakuping, kalvin alain', 'ysdystyy@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-05-29', 'afternoon', 'waiting_for_submission', '2025-05-15 15:52:43.643566', '2025-05-15 15:53:01.131130', 15, 167, 23, 'senior_high_graduating', '08', '03', '2002', 'Filipino', '', '', 'male', '1234', 'Purok 6, Taluksangay, Zamboanga City', 1, 'TALUKSANGAY ZAMBOANGA CITY', '2025-05-23', 0, 0, 1, 17, NULL, 'afternoon', 1),
(293, 'lakuping, kalvin alain', 'dsgsfdgfsg@gmail.com', '+6509072656256', 'SDHGHDGGDH', '', '2025-05-31', 'afternoon', 'waiting_for_submission', '2025-05-15 15:56:48.917022', '2025-05-15 15:57:05.074361', 11, 169, 7, 'senior_high_graduate', '05', '02', '2018', 'Filipiono', '', '', 'male', '1234', 'Purok 6, Taluksangay, Zamboanga City', 1, 'TALUKSANGAY ZAMBOANGA CITY', '2025-05-20', 0, 0, 1, 17, NULL, 'afternoon', 1),
(294, 'lakuping, kalvin alain', 'dsgsfdgfsg@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-05-23', 'morning', 'claimed', '2025-05-15 16:28:49.745566', '2025-05-15 16:29:08.721576', 12, 169, 23, 'senior_high_graduating', '05', '02', '2002', 'Filipiono', '', '', 'male', '1234', 'Purok 6, Taluksangay, Zamboanga City', 1, 'TALUKSANGAY ZAMBOANGA CITY', '2025-05-23', 0, 0, 1, 17, NULL, 'afternoon', 1),
(297, 'lakuping, kalvin alain', 'mieee3381@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-05-28', 'morning', 'submitted', '2025-05-16 02:14:07.672383', '2025-05-16 02:14:36.921875', 11, 175, 15, 'senior_high_graduating', '03', '02', '2010', 'Filipiono', '', '', 'male', '12345678', 'Taluksangay, Taluksangay, Zamboanga City', 1, 'Tetuan Zamboanga City', '2025-05-21', 0, 0, 1, 17, NULL, 'afternoon', 1),
(298, 'lakuping, kalvin alain', 'jon.jhetuna@gmail.com', '+6509072656256', 'Asia Academic School', '', '2025-05-31', 'morning', 'claimed', '2025-05-16 07:54:01.361127', '2025-05-16 08:01:56.104851', 11, 176, 22, 'senior_high_graduating', '03', '02', '2003', 'Filipino', '', '', 'male', '3334', 'Taluksangay, Taluksangay, Zamboanga City', 1, 'Tetuan Zamboanga City', '2025-05-23', 0, 0, 1, 17, NULL, 'afternoon', 1),
(299, 'Faminiano, Christian Jude', 'meow1@gmail.com', '09708701567', 'Molave Techinica Vocational School', '', '2025-07-30', 'morning', 'rescheduled', '2025-06-19 17:12:08.191254', '2025-06-19 17:31:37.011378', 15, 178, 21, 'senior_high_graduating', '10', '12', '2003', 'Filipino', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, San Jose Cawa-Cawa, Zamboanga City', 1, 'Mabini St Makugihon Molave, Zamboanga Del Sur', '2025-06-05', 0, 0, NULL, NULL, NULL, NULL, 0),
(300, 'Faminiano, Christian Jude', 'meow1@gmail.com', '09708701567', 'Molave Techinica Vocational School', '', '2025-07-21', 'morning', 'rescheduled', '2025-06-19 17:31:37.058194', '2025-06-19 17:47:04.355583', 15, 178, 21, 'senior_high_graduating', '10', '12', '2003', 'Filipino', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, San Jose Cawa-Cawa, Zamboanga City', 1, 'Mabini St Makugihon Molave, Zamboanga Del Sur', '2025-06-05', 0, 0, NULL, NULL, NULL, NULL, 0),
(301, 'Faminiano, Christian Jude', 'meow1@gmail.com', '09708701567', 'Molave Techinica Vocational School', '', '2025-06-23', 'morning', 'claimed', '2025-06-19 17:47:04.399431', '2025-06-19 17:47:04.399431', 15, 178, 21, 'senior_high_graduating', '10', '12', '2003', 'Filipino', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, San Jose Cawa-Cawa, Zamboanga City', 1, 'Mabini St Makugihon Molave, Zamboanga Del Sur', '2025-06-05', 0, 0, NULL, NULL, NULL, NULL, 0),
(302, 'Faminiano, Christian Jude', 'meow1@gmail.com', '09708701567', 'mvtss', '', '2025-06-21', 'morning', 'rescheduled', '2025-06-19 17:51:14.314395', '2025-06-19 18:05:55.547505', 11, 178, 21, 'senior_high_graduate', '09', '12', '2003', 'filipino', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, fdsfasdf, Zamboanga City', 1, 'ASDasd', '2025-06-06', 0, 0, NULL, NULL, NULL, NULL, 0),
(303, 'Faminiano, Christian Jude', 'meow1@gmail.com', '09708701567', 'mvtss', '', '2025-06-23', 'morning', 'rescheduled', '2025-06-19 18:05:55.588330', '2025-06-19 18:53:53.114873', 11, 178, 21, 'senior_high_graduate', '09', '12', '2003', 'filipino', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, fdsfasdf, Zamboanga City', 1, 'ASDasd', '2025-06-06', 0, 0, NULL, NULL, NULL, NULL, 0),
(304, 'Faminiano, Christian Jude', 'meow1@gmail.com', '09708701567', 'mvtss', '', '2025-06-24', 'afternoon', 'rescheduled', '2025-06-19 18:53:53.181453', '2025-06-21 16:26:12.283668', 11, 178, 21, 'senior_high_graduate', '09', '12', '2003', 'filipino', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, fdsfasdf, Zamboanga City', 1, 'ASDasd', '2025-06-06', 0, 0, NULL, NULL, NULL, NULL, 0),
(305, 'Faminiano, Christian Jude', 'meow1@gmail.com', '09708701567', 'mvtss', '', '2025-06-26', 'morning', 'claimed', '2025-06-21 16:26:12.336039', '2025-06-21 16:27:25.934317', 11, 178, 21, 'senior_high_graduate', '09', '12', '2003', 'filipino', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, fdsfasdf, Zamboanga City', 1, 'ASDasd', '2025-06-06', 0, 0, NULL, NULL, NULL, NULL, 0),
(306, 'Faminiano, Christian Jude', 'meow1@gmail.com', '09708701567', 'Asdasd', '', '2025-06-25', 'morning', 'claimed', '2025-06-22 19:44:00.671121', '2025-06-22 19:44:13.629007', 12, 178, 21, 'senior_high_graduate', '09', '12', '2003', 'SADD', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, WEREWR, Zamboanga City', 1, 'asdad', '2025-06-05', 0, 0, NULL, NULL, NULL, NULL, 0),
(307, 'Faminiano, Christian Jude', 'meow1@gmail.com', '09708701567', 'ADasd', '', '2025-07-22', 'morning', 'claimed', '2025-06-23 17:39:39.333330', '2025-06-24 14:36:31.608848', 12, 178, 21, 'senior_high_graduating', '09', '12', '2003', 'ASDAD', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, SDASD, Zamboanga City', 1, 'ASD', '2025-06-04', 0, 0, NULL, NULL, NULL, NULL, 0),
(308, 'Faminiano, Christian Jude', 'meow3@gmail.com', '09708701567', 'asdfasdf', '', '2025-06-26', 'morning', 'submitted', '2025-06-24 18:00:31.082350', '2025-06-24 18:00:31.082350', 15, 179, 28, 'senior_high_graduate', '19', '12', '1996', 'asdfasdf', '', '', 'male', 'asdfasdf', 'Crystal Street San Jose Cawa-Cawa, 234234wqtafs, Zamboanga City', 1, 'sadfasdf', '2025-06-06', 0, 0, NULL, NULL, NULL, NULL, 0),
(309, 'mSDF, ASDF ASD', 'meow3@gmail.com', '3241345345', 'SAGADFG', '', '2025-06-26', 'morning', 'submitted', '2025-06-24 18:19:09.325521', '2025-06-24 19:31:19.691913', 12, 179, 17, 'senior_high_graduate', '19', '12', '2007', '2345345', '', '', 'male', '', '3452345, 2345345, DFASDG', 1, 'DFGDFG', '2025-06-09', 0, 0, 1, 17, NULL, 'afternoon', 1),
(310, 'Mike, Christian Jude', 'meow5@gmail.com', '09182738174', 'mvts', '', '2025-06-28', 'afternoon', 'waiting_for_test_details', '2025-06-24 21:19:51.495267', '2025-06-24 21:19:51.495267', 15, 180, 17, 'senior_high_graduating', '18', '12', '2007', 'qweqwe', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, qweqwe, Zamboanga City', 1, 'makgpasdjf', '2025-06-27', 0, 0, NULL, NULL, NULL, NULL, 0),
(311, 'Mic, Christian Jude', 'meow5@gmail.com', '3241252342', 'qwrqwtqwt', '', '2025-06-30', 'morning', 'submitted', '2025-06-24 21:22:46.257507', '2025-06-24 21:22:46.258501', 12, 180, 20, 'senior_high_graduate', '19', '12', '2004', 'qwerqwer', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, ewrwer, Zamboanga City', 1, 'qwetwqet', '2025-06-20', 0, 0, NULL, NULL, NULL, NULL, 0),
(312, 'Faminiano, Christian Jude', 'meow5@gmail.com', '09708701567', 'sdadsd', '', '2025-06-26', 'morning', 'submitted', '2025-06-25 03:11:08.671817', '2025-06-25 03:11:08.671817', 11, 180, 21, 'college', '19', '12', '2003', 'Fili', 'asdasd', 'wmsu_main', 'male', '', 'Crystal Street San Jose Cawa-Cawa, asdfasdf, Zamboanga City', 1, 'sadad', '', 0, 0, NULL, NULL, NULL, NULL, 0),
(313, 'Faminiano, Christian Jude', 'meow6@gmail.com', '09708701567', 'mvts', '', '2025-07-01', 'morning', 'waiting_for_test_details', '2025-06-25 03:31:12.784295', '2025-06-25 03:31:12.784295', 15, 181, 27, 'senior_high_graduate', '18', '12', '1997', 'Filipino', '', '', 'male', '', 'Crystal Street San Jose Cawa-Cawa, sdfsdf, Zamboanga City', 1, 'molave', '2025-06-12', 0, 0, NULL, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `base_examresult`
--

CREATE TABLE `base_examresult` (
  `id` bigint(20) NOT NULL,
  `serial_no` int(11) DEFAULT NULL,
  `app_no` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `school` varchar(255) NOT NULL,
  `exam_type` varchar(50) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `imported_by_id` int(11) DEFAULT NULL,
  `year` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_examresult`
--

INSERT INTO `base_examresult` (`id`, `serial_no`, `app_no`, `name`, `school`, `exam_type`, `created_at`, `updated_at`, `imported_by_id`, `year`) VALUES
(246, 1, 'CET-2024-001', 'John D. Mendoza', 'University of Manila', 'EAT', '2025-06-25 01:44:02.217656', '2025-06-25 01:44:02.217656', 177, '2025'),
(247, 2, 'CET-2024-015', 'Maria Cristina Santos', 'Pamantasan ng Lungsod ng Maynila', 'EAT', '2025-06-25 01:44:02.225866', '2025-06-25 01:44:02.225866', 177, '2025'),
(248, 3, 'CET-2024-023', 'Carlos A. Reyes', 'Polytechnic University of the Philippines', 'EAT', '2025-06-25 01:44:02.229263', '2025-06-25 01:44:02.229263', 177, '2025'),
(249, 4, 'CET-2024-042', 'Jennifer B. Gonzales', 'University of the East', 'EAT', '2025-06-25 01:44:02.232782', '2025-06-25 01:44:02.232782', 177, '2025'),
(250, 5, 'CET-2024-057', 'Michael R. Torres', 'Far Eastern University', 'EAT', '2025-06-25 01:44:02.237933', '2025-06-25 01:44:02.237933', 177, '2025'),
(251, 6, 'CET-2024-069', 'Sarah Jane Cruz', 'Ateneo de Manila University', 'EAT', '2025-06-25 01:44:02.237933', '2025-06-25 01:44:02.237933', 177, '2025'),
(252, 7, 'CET-2024-078', 'Paolo Miguel Tan', 'De La Salle University', 'EAT', '2025-06-25 01:44:02.253583', '2025-06-25 01:44:02.253583', 177, '2025'),
(253, 8, 'CET-2024-084', 'Angelica Marie Ramos', 'University of Santo Tomas', 'EAT', '2025-06-25 01:44:02.256694', '2025-06-25 01:44:02.256694', 177, '2025'),
(254, 9, 'CET-2024-091', 'Rafael D. Aquino', 'San Beda University', 'EAT', '2025-06-25 01:44:02.256694', '2025-06-25 01:44:02.256694', 177, '2025'),
(255, 10, 'CET-2024-103', 'Diana Rose Fernandez', 'Mapua University', 'EAT', '2025-06-25 01:44:02.256694', '2025-06-25 01:44:02.256694', 177, '2025'),
(256, 11, 'CET-2024-118', 'Christian James Lopez', 'National University', 'EAT', '2025-06-25 01:44:02.256694', '2025-06-25 01:44:02.256694', 177, '2025'),
(257, 12, 'CET-2024-124', 'Sofia Isabel Garcia', 'University of Asia and the Pacific', 'EAT', '2025-06-25 01:44:02.273662', '2025-06-25 01:44:02.273662', 177, '2025'),
(258, 13, 'CET-2024-137', 'Daniel Joseph Pascual', 'Lyceum of the Philippines University', 'EAT', '2025-06-25 01:44:02.273662', '2025-06-25 01:44:02.273662', 177, '2025'),
(259, 14, 'CET-2024-145', 'Samantha Nicole Dela Cruz', 'Adamson University', 'EAT', '2025-06-25 01:44:02.273662', '2025-06-25 01:44:02.273662', 177, '2025'),
(260, 15, 'CET-2024-156', 'Gabriel Antonio Santos', 'San Sebastian College', 'EAT', '2025-06-25 01:44:02.288652', '2025-06-25 01:44:02.288652', 177, '2025'),
(261, 16, 'CET-2024-168', 'Kimberly Joy Villanueva', 'Philippine Normal University', 'EAT', '2025-06-25 01:44:02.290184', '2025-06-25 01:44:02.290184', 177, '2025'),
(262, 17, 'CET-2024-177', 'Joshua Emmanuel Bautista', 'Technological University of the Philippines', 'EAT', '2025-06-25 01:44:02.290184', '2025-06-25 01:44:02.290184', 177, '2025'),
(263, 18, 'CET-2024-185', 'Jasmine Patricia Diaz', 'Miriam College', 'EAT', '2025-06-25 01:44:02.290184', '2025-06-25 01:44:02.290184', 177, '2025'),
(264, 19, 'CET-2024-192', 'Ryan Christopher Martinez', 'Arellano University', 'EAT', '2025-06-25 01:44:02.305812', '2025-06-25 01:44:02.305812', 177, '2025'),
(265, 20, 'CET-2024-207', 'Stephanie Grace Ocampo', 'Centro Escolar University', 'EAT', '2025-06-25 01:44:02.308805', '2025-06-25 01:44:02.309828', 177, '2025'),
(266, 1, 'CET-2024-001', 'John D. Mendoza', 'University of Manila', 'CET', '2025-06-25 03:26:21.465246', '2025-06-25 03:26:21.465246', 177, '2025'),
(267, 2, 'CET-2024-015', 'Maria Cristina Santos', 'Pamantasan ng Lungsod ng Maynila', 'CET', '2025-06-25 03:26:21.476246', '2025-06-25 03:26:21.476246', 177, '2025'),
(268, 3, 'CET-2024-023', 'Carlos A. Reyes', 'Polytechnic University of the Philippines', 'CET', '2025-06-25 03:26:21.479213', '2025-06-25 03:26:21.479213', 177, '2025'),
(269, 4, 'CET-2024-042', 'Jennifer B. Gonzales', 'University of the East', 'CET', '2025-06-25 03:26:21.484194', '2025-06-25 03:26:21.484194', 177, '2025'),
(270, 5, 'CET-2024-057', 'Michael R. Torres', 'Far Eastern University', 'CET', '2025-06-25 03:26:21.488182', '2025-06-25 03:26:21.488182', 177, '2025'),
(271, 6, 'CET-2024-069', 'Sarah Jane Cruz', 'Ateneo de Manila University', 'CET', '2025-06-25 03:26:21.491190', '2025-06-25 03:26:21.491190', 177, '2025'),
(272, 7, 'CET-2024-078', 'Paolo Miguel Tan', 'De La Salle University', 'CET', '2025-06-25 03:26:21.494200', '2025-06-25 03:26:21.494200', 177, '2025'),
(273, 8, 'CET-2024-084', 'Angelica Marie Ramos', 'University of Santo Tomas', 'CET', '2025-06-25 03:26:21.498155', '2025-06-25 03:26:21.498155', 177, '2025'),
(274, 9, 'CET-2024-091', 'Rafael D. Aquino', 'San Beda University', 'CET', '2025-06-25 03:26:21.503160', '2025-06-25 03:26:21.503160', 177, '2025'),
(275, 10, 'CET-2024-103', 'Diana Rose Fernandez', 'Mapua University', 'CET', '2025-06-25 03:26:21.507131', '2025-06-25 03:26:21.507131', 177, '2025'),
(276, 11, 'CET-2024-118', 'Christian James Lopez', 'National University', 'CET', '2025-06-25 03:26:21.510155', '2025-06-25 03:26:21.510155', 177, '2025'),
(277, 12, 'CET-2024-124', 'Sofia Isabel Garcia', 'University of Asia and the Pacific', 'CET', '2025-06-25 03:26:21.514115', '2025-06-25 03:26:21.514115', 177, '2025'),
(278, 13, 'CET-2024-137', 'Daniel Joseph Pascual', 'Lyceum of the Philippines University', 'CET', '2025-06-25 03:26:21.518104', '2025-06-25 03:26:21.518104', 177, '2025'),
(279, 14, 'CET-2024-145', 'Samantha Nicole Dela Cruz', 'Adamson University', 'CET', '2025-06-25 03:26:21.524088', '2025-06-25 03:26:21.524088', 177, '2025'),
(280, 15, 'CET-2024-156', 'Gabriel Antonio Santos', 'San Sebastian College', 'CET', '2025-06-25 03:26:21.528077', '2025-06-25 03:26:21.528077', 177, '2025'),
(281, 16, 'CET-2024-168', 'Kimberly Joy Villanueva', 'Philippine Normal University', 'CET', '2025-06-25 03:26:21.531067', '2025-06-25 03:26:21.531067', 177, '2025'),
(282, 17, 'CET-2024-177', 'Joshua Emmanuel Bautista', 'Technological University of the Philippines', 'CET', '2025-06-25 03:26:21.537052', '2025-06-25 03:26:21.537052', 177, '2025'),
(283, 18, 'CET-2024-185', 'Jasmine Patricia Diaz', 'Miriam College', 'CET', '2025-06-25 03:26:21.541040', '2025-06-25 03:26:21.541040', 177, '2025'),
(284, 19, 'CET-2024-192', 'Ryan Christopher Martinez', 'Arellano University', 'CET', '2025-06-25 03:26:21.545029', '2025-06-25 03:26:21.545029', 177, '2025'),
(285, 20, 'CET-2024-207', 'Stephanie Grace Ocampo', 'Centro Escolar University', 'CET', '2025-06-25 03:26:21.548024', '2025-06-25 03:26:21.548024', 177, '2025');

-- --------------------------------------------------------

--
-- Table structure for table `base_examscore`
--

CREATE TABLE `base_examscore` (
  `id` bigint(20) NOT NULL,
  `score` varchar(20) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `appointment_id` bigint(20) DEFAULT NULL,
  `app_no` varchar(50) DEFAULT NULL,
  `exam_type` varchar(50) DEFAULT NULL,
  `imported_by_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `school` varchar(255) DEFAULT NULL,
  `exam_date` date DEFAULT NULL,
  `oapr` varchar(20) DEFAULT NULL,
  `part1` varchar(20) DEFAULT NULL,
  `part2` varchar(20) DEFAULT NULL,
  `part3` varchar(20) DEFAULT NULL,
  `part4` varchar(20) DEFAULT NULL,
  `part5` varchar(20) DEFAULT NULL,
  `year` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_examscore`
--

INSERT INTO `base_examscore` (`id`, `score`, `created_at`, `updated_at`, `appointment_id`, `app_no`, `exam_type`, `imported_by_id`, `name`, `school`, `exam_date`, `oapr`, `part1`, `part2`, `part3`, `part4`, `part5`, `year`) VALUES
(48, '79', '2025-06-23 21:49:46.680591', '2025-06-23 21:49:46.680591', NULL, '10001', 'NAT', 177, 'John A Doe', 'Westview Academy', '2025-06-22', '79', '76', '84', '87', '79', '82', NULL),
(49, '80', '2025-06-23 21:49:46.688132', '2025-06-23 21:49:46.688132', NULL, '10002', 'NAT', 177, 'Jane B Smith', 'Central High', '2025-06-22', '80', '71', '85', '71', '93', '93', NULL),
(50, '82', '2025-06-23 21:49:46.707015', '2025-06-23 21:49:46.707015', NULL, '10003', 'NAT', 177, 'Carlos C Garcia', 'Eastwood High', '2025-06-22', '82', '93', '97', '75', '82', '97', NULL),
(51, '92', '2025-06-23 21:49:46.719675', '2025-06-23 21:49:46.720012', NULL, '10004', 'NAT', 177, 'Maria D Lopez', 'Central High', '2025-06-22', '92', '79', '87', '85', '76', '72', NULL),
(52, '78', '2025-06-23 21:49:46.727371', '2025-06-23 21:49:46.727371', NULL, '10005', 'NAT', 177, 'Anna E Brown', 'Central High', '2025-06-22', '78', '92', '77', '100', '97', '77', NULL),
(53, '85', '2025-06-23 21:49:46.736891', '2025-06-23 21:49:46.736891', NULL, '10006', 'NAT', 177, 'Luis F Santos', 'Central High', '2025-06-22', '85', '80', '90', '75', '98', '98', NULL),
(54, '95', '2025-06-23 21:49:46.742328', '2025-06-23 21:49:46.742328', NULL, '10007', 'NAT', 177, 'Sophia G Johnson', 'Westview Academy', '2025-06-22', '95', '82', '95', '82', '87', '91', NULL),
(55, '71', '2025-06-23 21:49:46.750843', '2025-06-23 21:49:46.750843', NULL, '10008', 'NAT', 177, 'Mark H Cruz', 'Westview Academy', '2025-06-22', '71', '93', '76', '87', '71', '76', NULL),
(56, '92', '2025-06-23 21:49:46.756465', '2025-06-23 21:49:46.756528', NULL, '10009', 'NAT', 177, 'Ella I Lee', 'Eastwood High', '2025-06-22', '92', '93', '71', '78', '100', '84', NULL),
(57, '85', '2025-06-23 21:49:46.763223', '2025-06-23 21:49:46.763733', NULL, '10010', 'NAT', 177, 'Daniel J Martin', 'Southern Institute', '2025-06-22', '85', '98', '91', '96', '74', '77', NULL),
(58, '79', '2025-06-23 21:50:38.885248', '2025-06-23 21:50:38.885248', NULL, '10001', 'EAT', 177, 'John A Doe', 'Westview Academy', '2025-06-22', '79', '76', '84', '87', '79', '82', NULL),
(59, '80', '2025-06-23 21:50:38.892957', '2025-06-23 21:50:38.892957', NULL, '10002', 'EAT', 177, 'Jane B Smith', 'Central High', '2025-06-22', '80', '71', '85', '71', '93', '93', NULL),
(60, '82', '2025-06-23 21:50:38.899566', '2025-06-23 21:50:38.899566', NULL, '10003', 'EAT', 177, 'Carlos C Garcia', 'Eastwood High', '2025-06-22', '82', '93', '97', '75', '82', '97', NULL),
(61, '92', '2025-06-23 21:50:38.912275', '2025-06-23 21:50:38.912275', NULL, '10004', 'EAT', 177, 'Maria D Lopez', 'Central High', '2025-06-22', '92', '79', '87', '85', '76', '72', NULL),
(62, '78', '2025-06-23 21:50:38.917594', '2025-06-23 21:50:38.917689', NULL, '10005', 'EAT', 177, 'Anna E Brown', 'Central High', '2025-06-22', '78', '92', '77', '100', '97', '77', NULL),
(63, '85', '2025-06-23 21:50:38.925130', '2025-06-23 21:50:38.925202', NULL, '10006', 'EAT', 177, 'Luis F Santos', 'Central High', '2025-06-22', '85', '80', '90', '75', '98', '98', NULL),
(64, '95', '2025-06-23 21:50:38.931353', '2025-06-23 21:50:38.931353', NULL, '10007', 'EAT', 177, 'Sophia G Johnson', 'Westview Academy', '2025-06-22', '95', '82', '95', '82', '87', '91', NULL),
(65, '71', '2025-06-23 21:50:38.940210', '2025-06-23 21:50:38.940719', NULL, '10008', 'EAT', 177, 'Mark H Cruz', 'Westview Academy', '2025-06-22', '71', '93', '76', '87', '71', '76', NULL),
(66, '92', '2025-06-23 21:50:38.946781', '2025-06-23 21:50:38.946781', NULL, '10009', 'EAT', 177, 'Ella I Lee', 'Eastwood High', '2025-06-22', '92', '93', '71', '78', '100', '84', NULL),
(67, '85', '2025-06-23 21:50:38.952534', '2025-06-23 21:50:38.952534', NULL, '10010', 'EAT', 177, 'Daniel J Martin', 'Southern Institute', '2025-06-22', '85', '98', '91', '96', '74', '77', NULL),
(68, '79', '2025-06-24 21:10:23.926058', '2025-06-24 21:10:23.926058', NULL, '10001', 'CET', 177, 'John A Doe', 'Westview Academy', '2025-06-22', '79', '76', '84', '87', '79', '82', NULL),
(69, '80', '2025-06-24 21:10:23.947664', '2025-06-24 21:10:23.947664', NULL, '10002', 'CET', 177, 'Jane B Smith', 'Central High', '2025-06-22', '80', '71', '85', '71', '93', '93', NULL),
(70, '82', '2025-06-24 21:10:23.953638', '2025-06-24 21:10:23.953638', NULL, '10003', 'CET', 177, 'Carlos C Garcia', 'Eastwood High', '2025-06-22', '82', '93', '97', '75', '82', '97', NULL),
(71, '92', '2025-06-24 21:10:23.958624', '2025-06-24 21:10:23.958624', NULL, '10004', 'CET', 177, 'Maria D Lopez', 'Central High', '2025-06-22', '92', '79', '87', '85', '76', '72', NULL),
(72, '78', '2025-06-24 21:10:23.966571', '2025-06-24 21:10:23.966571', NULL, '10005', 'CET', 177, 'Anna E Brown', 'Central High', '2025-06-22', '78', '92', '77', '100', '97', '77', NULL),
(73, '85', '2025-06-24 21:10:23.979709', '2025-06-24 21:10:23.979709', NULL, '10006', 'CET', 177, 'Luis F Santos', 'Central High', '2025-06-22', '85', '80', '90', '75', '98', '98', NULL),
(74, '95', '2025-06-24 21:10:23.984631', '2025-06-24 21:10:23.984631', NULL, '10007', 'CET', 177, 'Sophia G Johnson', 'Westview Academy', '2025-06-22', '95', '82', '95', '82', '87', '91', NULL),
(75, '71', '2025-06-24 21:10:23.984631', '2025-06-24 21:10:23.984631', NULL, '10008', 'CET', 177, 'Mark H Cruz', 'Westview Academy', '2025-06-22', '71', '93', '76', '87', '71', '76', NULL),
(76, '92', '2025-06-24 21:10:23.984631', '2025-06-24 21:10:23.984631', NULL, '10009', 'CET', 177, 'Ella I Lee', 'Eastwood High', '2025-06-22', '92', '93', '71', '78', '100', '84', NULL),
(77, '85', '2025-06-24 21:10:24.001247', '2025-06-24 21:10:24.001247', NULL, '10010', 'CET', 177, 'Daniel J Martin', 'Southern Institute', '2025-06-22', '85', '98', '91', '96', '74', '77', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `base_faq`
--

CREATE TABLE `base_faq` (
  `id` bigint(20) NOT NULL,
  `question` longtext NOT NULL,
  `answer` longtext NOT NULL,
  `category` varchar(100) NOT NULL,
  `icon` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `order` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_faq`
--

INSERT INTO `base_faq` (`id`, `question`, `answer`, `category`, `icon`, `is_active`, `order`, `created_at`, `updated_at`) VALUES
(4, 'ksjdkjskdj', 'sdjdkjkd', 'General', 'fas fa-question', 1, 0, '2025-04-20 03:57:27.526571', '2025-04-20 03:57:27.526571');

-- --------------------------------------------------------

--
-- Table structure for table `base_otpverification`
--

CREATE TABLE `base_otpverification` (
  `id` bigint(20) NOT NULL,
  `email` varchar(254) NOT NULL,
  `otp_code` varchar(6) NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expires_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_otpverification`
--

INSERT INTO `base_otpverification` (`id`, `email`, `otp_code`, `is_verified`, `created_at`, `expires_at`) VALUES
(4, 'kalvinlakuping123@gmail.com', '423664', 0, '2025-05-15 18:52:41.148954', '2025-05-16 03:02:41.132842');

-- --------------------------------------------------------

--
-- Table structure for table `base_program`
--

CREATE TABLE `base_program` (
  `id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `code` varchar(50) NOT NULL,
  `description` longtext NOT NULL,
  `icon` varchar(50) NOT NULL,
  `capacity_limit` int(11) NOT NULL,
  `availability_date` date NOT NULL,
  `requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`requirements`)),
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `auto_approve_appointments` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_program`
--

INSERT INTO `base_program` (`id`, `name`, `code`, `description`, `icon`, `capacity_limit`, `availability_date`, `requirements`, `status`, `created_at`, `updated_at`, `auto_approve_appointments`) VALUES
(11, 'College Entrance Test', 'CET', 'Launch your college journey with our College Entrance Exam! Designed for high school students, this comprehensive test evaluates your proficiency in mathematics, critical reading, and writing—key skills for academic success. Administered multiple times a year.', 'graduation-cap', 150, '2025-06-20', '[\"School ID\", \"2X2 picture\", \"SHS report card\", \"birth\"]', 'active', '2025-03-09 04:34:40.544229', '2025-06-19 17:28:37.678895', 0),
(12, 'Nursing Aptitude Test', 'NAT', 'The Nursing Aptitude Test is designed to assess the skills, knowledge, and qualities essential for a successful career in nursing. It evaluates critical thinking, problem-solving abilities, communication skills, and basic healthcare knowledge', 'user-nurse', 140, '2025-03-28', '[\"CET RESULT\", \"Report card\", \"2x2 picture\", \"220 pesos\"]', 'active', '2025-03-09 14:49:57.821160', '2025-03-24 07:50:38.831967', 0),
(15, 'Engineering Aptitude Test', 'EAT', 'The Engineering Aptitude Test is a comprehensive assessment designed to evaluate the core skills and knowledge required for a successful career in engineering. It measures logical reasoning, mathematical proficiency, problem-solving abilities, and understanding of fundamental engineering concepts.', 'gears', 2, '2025-06-26', '[\"Report Card\", \"yourself\"]', 'active', '2025-03-10 06:45:02.020804', '2025-06-24 17:57:20.217419', 1);

-- --------------------------------------------------------

--
-- Table structure for table `base_testcenter`
--

CREATE TABLE `base_testcenter` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(20) NOT NULL,
  `address` longtext DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_testcenter`
--

INSERT INTO `base_testcenter` (`id`, `name`, `code`, `address`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'WESTERN MINDANAO STATE UNIVERSITY', 'WMSU', 'BALIWSASAN ROAD', 1, '2025-04-10 15:37:08.530691', '2025-04-10 15:37:08.530691'),
(2, 'PAGADIAN SCIENCE HIGH SCHOOL', '2', 'PAGADIAN', 1, '2025-06-23 22:02:11.038218', '2025-06-23 22:02:11.038218');

-- --------------------------------------------------------

--
-- Table structure for table `base_testroom`
--

CREATE TABLE `base_testroom` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `room_code` varchar(20) NOT NULL,
  `capacity` int(11) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `test_center_id` bigint(20) NOT NULL,
  `assigned_count` int(11) NOT NULL,
  `available_capacity` int(11) NOT NULL,
  `time_slot` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_testroom`
--

INSERT INTO `base_testroom` (`id`, `name`, `room_code`, `capacity`, `is_active`, `test_center_id`, `assigned_count`, `available_capacity`, `time_slot`) VALUES
(17, 'ccs', 'lr3', 30, 1, 1, 18, 12, 'afternoon'),
(18, 'Room 1', '1', 30, 1, 2, 0, 30, 'morning');

-- --------------------------------------------------------

--
-- Table structure for table `base_testsession`
--

CREATE TABLE `base_testsession` (
  `id` bigint(20) NOT NULL,
  `exam_type` varchar(50) NOT NULL,
  `registration_start_date` date NOT NULL,
  `registration_end_date` date NOT NULL,
  `exam_date` date NOT NULL,
  `description` longtext DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `base_testsession`
--

INSERT INTO `base_testsession` (`id`, `exam_type`, `registration_start_date`, `registration_end_date`, `exam_date`, `description`, `status`, `created_at`, `updated_at`, `created_by_id`) VALUES
(14, 'CET', '2025-06-23', '2025-06-28', '2025-06-30', NULL, 'ONGOING', '2025-06-19 17:24:01.315848', '2025-06-19 17:24:01.315848', 177),
(15, 'EAT', '2025-06-30', '2025-07-30', '2025-07-30', NULL, 'ONGOING', '2025-06-19 17:35:10.266652', '2025-06-19 17:46:07.396707', 177),
(16, 'NAT', '2025-06-25', '2025-07-15', '2025-07-22', NULL, 'COMPLETED', '2025-06-24 18:16:35.350544', '2025-06-25 01:25:46.083564', 177);

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(15, 'base', 'announcement'),
(8, 'base', 'appointment'),
(11, 'base', 'examresult'),
(10, 'base', 'examscore'),
(9, 'base', 'faq'),
(16, 'base', 'otpverification'),
(7, 'base', 'program'),
(12, 'base', 'testcenter'),
(13, 'base', 'testroom'),
(14, 'base', 'testsession'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-03-06 14:43:44.656613'),
(2, 'auth', '0001_initial', '2025-03-06 14:43:44.961877'),
(3, 'admin', '0001_initial', '2025-03-06 14:43:45.017549'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-03-06 14:43:45.039971'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-03-06 14:43:45.045971'),
(6, 'contenttypes', '0002_remove_content_type_name', '2025-03-06 14:43:45.124624'),
(7, 'auth', '0002_alter_permission_name_max_length', '2025-03-06 14:43:45.151417'),
(8, 'auth', '0003_alter_user_email_max_length', '2025-03-06 14:43:45.168212'),
(9, 'auth', '0004_alter_user_username_opts', '2025-03-06 14:43:45.183194'),
(10, 'auth', '0005_alter_user_last_login_null', '2025-03-06 14:43:45.219850'),
(11, 'auth', '0006_require_contenttypes_0002', '2025-03-06 14:43:45.222159'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2025-03-06 14:43:45.226792'),
(13, 'auth', '0008_alter_user_username_max_length', '2025-03-06 14:43:45.250495'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2025-03-06 14:43:45.270836'),
(15, 'auth', '0010_alter_group_name_max_length', '2025-03-06 14:43:45.296504'),
(16, 'auth', '0011_update_proxy_permissions', '2025-03-06 14:43:45.305153'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2025-03-06 14:43:45.320651'),
(18, 'base', '0001_initial', '2025-03-06 14:43:45.334903'),
(19, 'sessions', '0001_initial', '2025-03-06 14:43:45.366828'),
(20, 'base', '0002_alter_program_availability_date_and_more', '2025-03-06 18:42:55.359424'),
(21, 'base', '0003_appointment_user', '2025-03-12 13:39:49.965238'),
(22, 'base', '0004_alter_appointment_status', '2025-03-18 08:54:56.734191'),
(23, 'base', '0005_faq', '2025-03-18 08:54:56.806051'),
(24, 'base', '0006_program_auto_approve_appointments', '2025-03-21 14:43:54.075223'),
(25, 'base', '0007_appointment_application_number', '2025-03-22 17:07:19.557831'),
(26, 'base', '0008_examscore', '2025-03-27 12:37:13.543834'),
(27, 'base', '0009_remove_appointment_application_number', '2025-03-27 14:56:42.718762'),
(28, 'base', '0010_examresult_examscore_app_no_examscore_exam_type_and_more', '2025-04-01 17:13:05.473142'),
(29, 'base', '0011_appointment_age_appointment_applicant_type_and_more', '2025-04-07 09:03:07.561837'),
(30, 'base', '0012_testcenter_appointment_is_submitted_and_more', '2025-04-10 14:56:26.560972'),
(31, 'base', '0013_appointment_test_center_address_and_more', '2025-04-10 19:20:10.237976'),
(32, 'base', '0014_remove_appointment_test_center_address_and_more', '2025-04-10 20:17:01.130604'),
(33, 'base', '0015_testroom_assigned_count_testroom_available_capacity', '2025-04-12 17:38:56.930287'),
(34, 'base', '0016_alter_appointment_status', '2025-04-14 18:59:56.267279'),
(35, 'base', '0017_testroom_time_slot', '2025-04-18 09:02:48.510865'),
(36, 'base', '0018_alter_appointment_status', '2025-04-19 02:49:22.035033'),
(37, 'base', '0019_announcement', '2025-04-19 07:41:45.513202'),
(38, 'base', '0020_examscore_exam_date_examscore_oapr_examscore_part1_and_more', '2025-04-20 09:47:59.951067'),
(39, 'base', '0021_appointment_assigned_test_time_slot_and_more', '2025-04-29 18:55:01.572967'),
(40, 'base', '0022_otpverification', '2025-05-15 18:34:08.157330'),
(41, 'base', '0023_alter_appointment_status', '2025-06-19 19:05:42.934540'),
(42, 'base', '0024_add_year_to_examresult', '2025-06-21 18:58:08.238613'),
(43, 'base', '0025_add_year_to_examscore', '2025-06-23 20:20:23.006046');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `base_announcement`
--
ALTER TABLE `base_announcement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_announcement_created_by_id_60c3675f_fk_auth_user_id` (`created_by_id`);

--
-- Indexes for table `base_appointment`
--
ALTER TABLE `base_appointment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `base_appointment_email_program_id_preferr_7b6717a8_uniq` (`email`,`program_id`,`preferred_date`,`time_slot`),
  ADD KEY `base_appointment_program_id_f914e09f_fk_base_program_id` (`program_id`),
  ADD KEY `base_appointment_user_id_6d1fd997_fk_auth_user_id` (`user_id`),
  ADD KEY `base_appointment_test_center_id_d99a909b_fk_base_testcenter_id` (`test_center_id`),
  ADD KEY `base_appointment_test_room_id_c7560800_fk_base_testroom_id` (`test_room_id`),
  ADD KEY `base_appointment_test_session_id_a5d1b9fc_fk_base_testsession_id` (`test_session_id`);

--
-- Indexes for table `base_examresult`
--
ALTER TABLE `base_examresult`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_examresult_imported_by_id_cda752b1_fk_auth_user_id` (`imported_by_id`),
  ADD KEY `base_examre_app_no_8622d4_idx` (`app_no`),
  ADD KEY `base_examre_exam_ty_f04212_idx` (`exam_type`),
  ADD KEY `base_examre_name_8aadf1_idx` (`name`),
  ADD KEY `base_examre_year_57a12b_idx` (`year`);

--
-- Indexes for table `base_examscore`
--
ALTER TABLE `base_examscore`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `appointment_id` (`appointment_id`),
  ADD KEY `base_examscore_imported_by_id_65ac3f63_fk_auth_user_id` (`imported_by_id`),
  ADD KEY `base_examsc_app_no_b1f166_idx` (`app_no`),
  ADD KEY `base_examsc_exam_ty_9851a3_idx` (`exam_type`),
  ADD KEY `base_examsc_name_95e506_idx` (`name`),
  ADD KEY `base_examsc_year_b66fd9_idx` (`year`);

--
-- Indexes for table `base_faq`
--
ALTER TABLE `base_faq`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `base_otpverification`
--
ALTER TABLE `base_otpverification`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `base_program`
--
ALTER TABLE `base_program`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `base_testcenter`
--
ALTER TABLE `base_testcenter`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `base_testroom`
--
ALTER TABLE `base_testroom`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_testroom_test_center_id_ca1ebc31_fk_base_testcenter_id` (`test_center_id`);

--
-- Indexes for table `base_testsession`
--
ALTER TABLE `base_testsession`
  ADD PRIMARY KEY (`id`),
  ADD KEY `base_testsession_created_by_id_6f3e4771_fk_auth_user_id` (`created_by_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `base_announcement`
--
ALTER TABLE `base_announcement`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `base_appointment`
--
ALTER TABLE `base_appointment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=314;

--
-- AUTO_INCREMENT for table `base_examresult`
--
ALTER TABLE `base_examresult`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=286;

--
-- AUTO_INCREMENT for table `base_examscore`
--
ALTER TABLE `base_examscore`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `base_faq`
--
ALTER TABLE `base_faq`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `base_otpverification`
--
ALTER TABLE `base_otpverification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `base_program`
--
ALTER TABLE `base_program`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `base_testcenter`
--
ALTER TABLE `base_testcenter`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `base_testroom`
--
ALTER TABLE `base_testroom`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `base_testsession`
--
ALTER TABLE `base_testsession`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_announcement`
--
ALTER TABLE `base_announcement`
  ADD CONSTRAINT `base_announcement_created_by_id_60c3675f_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_appointment`
--
ALTER TABLE `base_appointment`
  ADD CONSTRAINT `base_appointment_program_id_f914e09f_fk_base_program_id` FOREIGN KEY (`program_id`) REFERENCES `base_program` (`id`),
  ADD CONSTRAINT `base_appointment_test_center_id_d99a909b_fk_base_testcenter_id` FOREIGN KEY (`test_center_id`) REFERENCES `base_testcenter` (`id`),
  ADD CONSTRAINT `base_appointment_test_room_id_c7560800_fk_base_testroom_id` FOREIGN KEY (`test_room_id`) REFERENCES `base_testroom` (`id`),
  ADD CONSTRAINT `base_appointment_test_session_id_a5d1b9fc_fk_base_testsession_id` FOREIGN KEY (`test_session_id`) REFERENCES `base_testsession` (`id`),
  ADD CONSTRAINT `base_appointment_user_id_6d1fd997_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_examresult`
--
ALTER TABLE `base_examresult`
  ADD CONSTRAINT `base_examresult_imported_by_id_cda752b1_fk_auth_user_id` FOREIGN KEY (`imported_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_examscore`
--
ALTER TABLE `base_examscore`
  ADD CONSTRAINT `base_examscore_appointment_id_baf92016_fk_base_appointment_id` FOREIGN KEY (`appointment_id`) REFERENCES `base_appointment` (`id`),
  ADD CONSTRAINT `base_examscore_imported_by_id_65ac3f63_fk_auth_user_id` FOREIGN KEY (`imported_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `base_testroom`
--
ALTER TABLE `base_testroom`
  ADD CONSTRAINT `base_testroom_test_center_id_ca1ebc31_fk_base_testcenter_id` FOREIGN KEY (`test_center_id`) REFERENCES `base_testcenter` (`id`);

--
-- Constraints for table `base_testsession`
--
ALTER TABLE `base_testsession`
  ADD CONSTRAINT `base_testsession_created_by_id_6f3e4771_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
